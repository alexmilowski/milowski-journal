function GridAverage(service) {
   this.service = service;
   this.columns = [];
   this.columns.push({ uri: "http://mesonet.info/id" });
   this.columns.push({ uri: "http://mesonet.info/lat" });
   this.columns.push({ uri: "http://mesonet.info/long" });
   //this.columns.push({ uri: "http://mesonet.info/airTemperature", unit: "http://qudt.org/vocab/unit#DegreeFahrenheit" });
   this.columns.push({ uri: "http://mesonet.info/airTemperature", unit: "http://qudt.org/vocab/unit#DegreeCelsius" });
   this.resolution = 1;
}

GridAverage.prototype.apply = function(region,startDateTime,endDateTime,quadSize) {
   var mr = new MapReduce();
   this.mr = mr;
   this.region = region;
   var gridavg = this;
   mr.parallelMax = 4;
   mr.init(this.service); 
   for (var i=0; i<this.columns.length; i++) {
      mr.columns.push(this.columns[i]);
   }
   if (this.mrlog) {
      mr.log = this.mrlog;
   }
   if (this.onComplete) {
      mr.onComplete = function() {
         gridavg.onComplete(mr.context.reduction);
      };
   }
   mr.mapper = function(data) {
      var cells = {};
      var diffLat = Math.abs(mr.context.quadrangle[0]-mr.context.quadrangle[2]);
      var diffLon = Math.abs(mr.context.quadrangle[1]-mr.context.quadrangle[3]);
      var dimLat = Math.ceil(diffLat / gridavg.resolution);
      var dimLon = Math.ceil(diffLon / gridavg.resolution);
      for (var i=0; i<data.length; i++) {
         if (data[i][3]===null || isNaN(data[i][3])) {
            continue;
         }
         //console.log(data[i][0]+": "+data[i][3]);
         var latitude = data[i][1];
         var longitude = data[i][2];
         var latOffset = Math.abs(gridavg.region[0] - latitude);
         var longOffset = Math.abs(gridavg.region[1] - longitude);
         var position = [ Math.floor(latOffset / gridavg.resolution), Math.floor(longOffset / gridavg.resolution) ];
         if (dimLat==position[0]) {
            position[0]--;
         }
         if (dimLon==position[1]) {
            position[1]--;
         }
         var key = position[0]+","+position[1];
         //console.log(latitude+","+longitude+" => "+key);
         
         var cell = cells[key];
         if (!cell) {
            cell = {
               position: position,
               values: []
            };
            cells[key] = cell;
         } 
         
         cell.values.push(data[i][3]);
      }
      for (var key in cells) {
         var cell = cells[key];
         cell.mean = cell.values.reduce(function(previous,current) { return previous+current}) / cell.values.length;
         var sdev = Math.sqrt(
            cell.values.map(
               function(current) { 
                  var diff = current - cell.mean;
                  return diff*diff;
               }
            ).reduce(function(previous,current) { return previous+current; }) / cell.values.length);
         //console.log("sdev: "+sdev+" on "+cell.values.length+" values, mean: "+cell.mean);
         var tolerance = sdev<1 ? 3 : 3*sdev;
         cell.accepted = [];
         for (var i=0; i<cell.values.length; i++) {
            //console.log(cell.values[i]+" vs "+cell.mean+" "+tolerance);
            if (Math.abs(cell.mean - cell.values[i])<tolerance) {
               cell.accepted.push(cell.values[i]);
            }
         }
         //console.log(cell.accepted);
         cell.finalMean = cell.accepted.length==0 ? cell.mean : cell.accepted.reduce(function(previous,current) { return previous+current}) / cell.accepted.length;
      }
      return cells;      
   }
   mr.reducer = function(data) {
      var diffLat = Math.abs(mr.context.quadrangle[0]-mr.context.quadrangle[2]);
      var diffLon = Math.abs(mr.context.quadrangle[1]-mr.context.quadrangle[3]);
      var dimLat = Math.ceil(diffLat / gridavg.resolution);
      var dimLon = Math.ceil(diffLon / gridavg.resolution);
      var grid = [];
      for (var i=0; i<dimLon; i++) {
         var row = [];
         grid.push(row);
         for (var j=0; j<dimLat; j++) {
            row[j] = { value: Number.NaN, means: [] };
         }
      }
      for (var i=0; i<data.length; i++) {
         for (var key in data[i]) {
            var cell = data[i][key];
            try {
               var gridCell = grid[cell.position[1]][cell.position[0]];
               gridCell.means.push(cell.finalMean);
               gridCell.value = gridCell.means.reduce(function(previous,current) { return previous+current}) / gridCell.means.length;
            } catch (ex) {
               console.log("Cannot process grid cell "+key+" at position "+i);
               throw ex;
            }
         }
      }
      return grid;
   }
   mr.apply(region,startDateTime,endDateTime,quadSize);
}