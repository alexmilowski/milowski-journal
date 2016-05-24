function MapReduce() {
   this.parallelMax = 1;
}

MapReduce.prototype.init = function(uri) {
   this.baseService = uri;
   this.timeDuration ={
      minutes: 30,
      value: 30*60*1000
   }
   this.internal = [
      { uri: "http://mesonet.info/lat" },
      { uri: "http://mesonet.info/long" },
      { uri: "http://mesonet.info/receivedAt" }
   ];
   this.columns = [];
   this.columns.all = false;
   this.mapper = function(d) { return d;};
   this.reducer =  function(d) { return d;};
   this.onComplete = function() { console.log("Computation complete.");}
   this.clear();
   this.log = function(event,msg) {
      
   }
}

MapReduce.prototype.clear = function() {
   this.context = {
      sequences: [],
      fetchQueue: [],
      data: [],
      columns: [],
      reduction: [],
      requests: 0,
      finished: false
   };
}

MapReduce.prototype.setActions = function(mapper,reducer) {
   this.mapper = mapper;
   this.reducer = reducer;
}

MapReduce.prototype.toISO8601 = function(date) {
   var raw = date.toISOString();
   var decimal = raw.indexOf(".");
   return raw.substring(0,decimal)+raw.substring(decimal+4);
}

MapReduce.prototype.parseDuration = function(duration) {
   var minuteDuration = /^PT(\d+)M$/;
   var hourDuration = /^PT(\d+)H$/;
   var match = minuteDuration.exec(duration);
   if (match) {
      return parseInt(match[1])*60*1000;
   }
   var match = hourDuration.exec(duration);
   if (match) {
      return parseInt(match[1])*60*60*1000;
   }
}

MapReduce.prototype.parseLocation = function(v) {
   if (!v || v.lenght==0) {
      return null;
   }
   var parts= v.split(/\s+/);
   if (parts.length!=2 || (parts[0].length==0 || parts[1].length==0)) {
      return null;
   }
   return [ parseFloat(parts[0]), parseFloat(parts[1]) ];
}


MapReduce.prototype.getSequenceNumber = function(latSize,longSize,latPos,longPos) {
   var latp = 90 - latPos;
   var longp = longPos<0 ? 360 + longPos : longPos;
   var s = Math.floor(latp/latSize)*Math.floor(360/longSize) + Math.floor(longp/longSize) + 1;
   return s;
}

MapReduce.prototype.getSequenceNumberLocation = function(latSize,lonSize,s) {
   var latN = 180/latSize;
   var lonN = 360/lonSize;
   var z = (s-1)%(latN*lonN);
   var lon = (z%lonN)*lonSize;
   return [90 - Math.floor(z/lonN)*latSize,lon>180 ? lon-360 : lon];
}

MapReduce.prototype.getSequenceNumbers = function(quadrangle,size) {
   if (typeof size == undefined) {
      size = 5;
   }
   var ul = this.getSequenceNumber(size,size,quadrangle[0],quadrangle[1]);
   var ur = this.getSequenceNumber(size,size,quadrangle[0],quadrangle[3]);
   var ll = this.getSequenceNumber(size,size,quadrangle[2],quadrangle[1]);
   var lr = this.getSequenceNumber(size,size,quadrangle[2],quadrangle[3]);
   // test for boundary conditions with lr so we don't get too many
   var lrPos = this.getSequenceNumberLocation(size,size,lr);
   if (lrPos[1]==quadrangle[3]) {
      ur--;
      lr--;
   }
   if (lrPos[0]==quadrangle[2]) {
      var d = 360/size;
      ll -= d;
      lr -= d;
   }
   //console.log(ul+","+ur+","+ll+","+lr);
   var longCount = 360/size;
   var latCount = 180/size;
   
   var seqs = [];

   var longDiff = ul > ur ? longCount - (ul - 1) % longCount + ur % longCount : ur - ul + 1;
   var latDiff = Math.floor((ll - ul) / longCount) + 1
   var rowStart = Math.floor(ul / longCount);
   var rowEnd = rowStart + latDiff;
   var max = ul + longDiff;
   for (var j=rowStart; j<rowEnd; j++) {
      for (var i=ul; i<max; i++) {
         seqs.push((i-1) % longCount + 1 + j * longCount);
      }
   }
   
   return seqs;
}

MapReduce.prototype.findTimePartition = function(endDateTime) {
   var minutes = endDateTime.getMinutes();
   var seconds = endDateTime.getSeconds();
   var milliseconds = endDateTime.getMilliseconds();
   var partitionStart = new Date(endDateTime.getTime()-(minutes%this.timeDuration.minutes*60*1000)-seconds*1000-milliseconds);
   if (partitionStart.getTime()==endDateTime.getTime()) {
      return new Date(partitionStart.getTime()-this.timeDuration.value);
   } else {
      return partitionStart;
   }
}

MapReduce.prototype.apply = function(quadrangle,startDateTime,endDateTime,size) {
   this.startedAt = new Date();
   this.clear();
   this.transportTime = 0;
   this.mapTime = 0;
   this.reduceTime = 0;
   this.context.quadrangle = quadrangle;
   this.context.sequences = this.getSequenceNumbers(quadrangle,size);
   this.context.startDateTime = startDateTime;
   this.context.endDateTime = endDateTime;
   //var firstStart = new Date(endDateTime.getTime()-30*60*1000);
   var firstStart = this.findTimePartition(endDateTime);
   for (var i=0; i<this.context.sequences.length; i++) {
      this.context.fetchQueue.push(this.baseService+"q/"+size+"/n/"+this.context.sequences[i]+"/"+this.toISO8601(firstStart));
   }
   this.context.requests = this.parallelMax < this.context.fetchQueue.length ? this.parallelMax : this.context.fetchQueue.length;
   for (var i=0; i<this.parallelMax; i++) {
      this.fetchNext(true);
   }
}

MapReduce.prototype.inQuadrangle = function(location,quadrangle) {
   return location[0]>=quadrangle[2] && location[0]<=quadrangle[0] &&
          location[1]>=quadrangle[1] && location[1]<=quadrangle[3];
}

MapReduce.prototype.fetchNext = function(noIncrement) {
   if (this.context.fetchQueue.length==0) {
      if (this.context.requests==0) {
         var start = new Date();
         this.reduce();
      }
      return;
   }
   var mr = this;
   var uri = this.context.fetchQueue.shift();
   this.log("request",uri);
   var request = new XMLHttpRequest();
   request.start = new Date();
   request.open("GET",uri,true);
   request.onreadystatechange = function() {
      if (request.readyState==4) {
         mr.transportTime += (new Date()).getTime()-request.start.getTime();
         if (request.status==200 || request.status==201) {
            setTimeout(function() {
               var start = new Date();
               mr.map(request.responseXML);
               mr.mapTime += (new Date()).getTime()-start.getTime();
               mr.context.requests--;
            },1);
         } else {
            mr.context.requests--;
         }
         setTimeout(function() {
            mr.fetchNext()
         },1);
      }
   };
   if (!noIncrement) {
      this.context.requests++;
   }
   request.send();
}


MapReduce.prototype.findMainPartition = function(xml,type) {
   // find the first partition that has an item
   var datasets = xml.getElementsByType(type);
   var dataset = null;
   for (var i=0; !dataset && i<datasets.length; i++) {
      if (xml.data.getValues(datasets[i].data.id,"pan:item").length>0) {
         dataset = datasets[i];
      }
   }
   return dataset;
}


MapReduce.prototype.map = function(xml) {
   document.data.implementation.attach(xml);
   xml.data.setMapping("pan","http://pantabular.org/");
   this.log("load",xml.baseURI);
   var dataset = this.findMainPartition(xml,"pan:Partition");
   var items = xml.data.getValues(dataset.data.id,"pan:item");
   var table = xml.getElementsBySubject(items[0])[0];
   // get the previous relation
   var targets = xml.data.getValues(dataset.data.id,"pan:previous");
   if (targets.length) {
      var startDate = null;
      var duration = null;
      
      var ranges = xml.data.getValues(targets[0],"pan:range");
      for (var i=0; i<ranges.length; i++) {
         var valueType = xml.data.getValues(ranges[i],"pan:valueType")[0];
         if (valueType=="http://www.w3.org/2001/XMLSchema#dateTime") {
            startDate = new Date(xml.data.getValues(ranges[i],"pan:start")[0]);
            duration = xml.data.getValues(ranges[i],"pan:length")[0];
         }
      }
      
      if (startDate) {
         if (startDate.getTime()>this.context.startDateTime.getTime()) {
            //console.log("Next: "+targets[0]+" "+startDate);
            this.context.fetchQueue.push(targets[0]);
         } else if (duration) {
            var timePeriod = this.parseDuration(duration);
            //console.log("Duration: "+durations[0]+" -> "+timePeriod);
            var endDate = new Date(startDate.getTime()+timePeriod);
            if (endDate.getTime()>this.context.startDateTime.getTime()) {
               this.context.fetchQueue.push(targets[0]);
            }                  
         } else {
            // No duration, skip
            //console.log(xml.baseURI+" Start date out of range "+startDate);
         }
      }
   }
   if (table.tBodies.length>0) {
      // process body 
      this.processTable(table);
   }
   
}

MapReduce.prototype.findColumn = function(table,property,unit) {
   var columns = table.ownerDocument.data.getSubjects("pan:property",property);
   for (var i=0; i<columns.length; i++) {
      if (unit) {
         var valueSpace = table.ownerDocument.data.getValues(columns[i],"pan:valueSpace");
         var columnUnit = table.ownerDocument.data.getValues(valueSpace[0],"pan:unit");
         if (unit!=columnUnit[0]) {
            continue;
         }
      }
      var subjects = table.ownerDocument.data.getSubjects("pan:column",columns[i]);
      if (subjects.length>0 && subjects[0]==table.data.id) {
         var elements = table.ownerDocument.getElementsBySubject(columns[i]);
         for (var j=0; j<elements.length; j++) {
            if (typeof elements[j].cellIndex != "undefined") {
               return elements[j];
            }
         }
      }
   }
   return null;
}

MapReduce.prototype.defineColumn = function(def,column) {
   def.index = column.cellIndex;
   def.metadata = {
      title:  column.ownerDocument.data.getValues(column.data.id,"pan:title")[0],
      property:  column.ownerDocument.data.getValues(column.data.id,"pan:property")[0],
      valueSpace: {}
   }
   var valueSpace = column.ownerDocument.data.getValues(column.data.id,"pan:valueSpace")[0];
   var datatypes = column.ownerDocument.data.getValues(valueSpace,"pan:datatype");
   def.metadata.valueSpace.datatype = column.ownerDocument.data.getValues(valueSpace,"pan:datatype")[0];
   def.metadata.valueSpace.symbol = column.ownerDocument.data.getValues(valueSpace,"pan:symbol")[0];
   def.metadata.valueSpace.quantity = column.ownerDocument.data.getValues(valueSpace,"pan:quantity")[0];
   def.metadata.valueSpace.unit = column.ownerDocument.data.getValues(valueSpace,"pan:unit")[0];
   if (def.metadata.valueSpace.datatype=="http://www.w3.org/2001/XMLSchema#int") {
      def.convert = function(v) { return parseInt(v); }
   } else if (def.metadata.valueSpace.datatype=="http://www.w3.org/2001/XMLSchema#float") {
      def.convert = function(v) { return parseFloat(v); }
   } else if (def.metadata.valueSpace.datatype=="http://www.w3.org/2001/XMLSchema#double") {
      def.convert = function(v) { return parseFloat(v); }
   } else if (def.metadata.valueSpace.datatype=="http://www.w3.org/2001/XMLSchema#decimal") {
      def.convert = function(v) { return parseFloat(v); }
   } else if (def.metadata.valueSpace.datatype=="http://www.w3.org/2001/XMLSchema#dateTime") {
      def.convert = function(v) { return new Date(v); }
   }
}

MapReduce.prototype.processTable = function(table) {
   if (this.context.columns.length==0) {
      this.context.columns = [];
      for (var i=0; i<this.internal.length; i++) {
         var property = this.internal[i];
         var def = { 
            uri: property.uri,
            unit: property.unit,
            index: -1,
            convert: function(v) { return v;}
         };
         this.context.columns.push(def);
         var column = this.findColumn(table,def.uri,def.unit);
         if (column) {
            this.defineColumn(def,column);
         } else {
            console.log("Cannot find column "+def.uri+" "+(def.unit ? ", unit "+def.unit : ""));
         }
      }
      var maxIndex = this.context.columns.length;
      // user properties for computation
      if (this.columns.all) {
         var columnSubjects = table.ownerDocument.data.getValues(table.data.id,"pan:column");
         for (var i=0; i<columnSubjects.length; i++) {
            var column = table.ownerDocument.getElementsBySubject(columnSubjects[i])[0];
            var def = {
               index: -1,
               convert: function(v) { return v;}
            };
            this.defineColumn(def,column);
            def.uri = def.metadata.property;
            def.unit = def.metadata.valueSpace.unit;
            this.context.columns.push(def);
            this.columns.push({
               uri: def.metadata.property,
               unit: def.metadata.valueSpace.unit,
               metadata: def.metadata
            });
         }
      } else {
         for (var p=0; p<this.columns.length; p++) {
            var property = this.columns[p];
            var def = { 
               uri: property.uri,
               unit: property.unit,
               index: -1,
               convert: function(v) { return v;}
            };
            this.context.columns.push(def);
            var column = this.findColumn(table,def.uri,def.unit);
            if (column) {
               this.defineColumn(def,column);
               property.metadata = def.metadata;
            }
         }
      }
   }
   
   var startTime = this.context.startDateTime.getTime();
   var endTime = this.context.endDateTime.getTime();
   var dataset = [];
   var internalLatPos = 0;
   var internalLongPos = 1;
   var internalDateTimePos = 2;
   for (var i=0; i<table.tBodies.length; i++) {
      for (var c=0; c<this.context.columns.length; c++) {
         this.context.columns[c].value = null;
      }
      for (var j=0; j<table.tBodies[i].rows.length; j++) {
         if (table.tBodies[i].rows[j].data && table.tBodies[i].rows[j].data.types.indexOf("http://pantabular.org/ColumnSet")>=0) {
            for (c=0; c<this.context.columns.length; c++) {
               if (this.context.columns[c].index>=table.tBodies[i].rows[j].cells.length) {
                  this.context.columns[c].defaultValue = false;
                  this.context.columns[c].value = null;
                  continue;
               }
               this.context.columns[c].defaultValue = true;
               var text = table.tBodies[i].rows[j].cells[this.context.columns[c].index].textContent;
               this.context.columns[c].value = text.length>0 ? this.context.columns[c].convert(text) : null;
            }
            continue;
         }
         for (c=0; c<this.context.columns.length; c++) {
            if (this.context.columns[c].index>=table.tBodies[i].rows[j].cells.length) {
               if (!this.context.columns[c].defaultValue) {
                  this.context.columns[c].value = null;
               }
               continue;
            }
            var text = table.tBodies[i].rows[j].cells[this.context.columns[c].index].textContent;
            if (this.context.columns[c].defaultValue && text.length==0) {
               continue;
            }
            this.context.columns[c].value = text.length>0 ? this.context.columns[c].convert(text) : null;
         }
         var location = [ this.context.columns[internalLatPos].value, this.context.columns[internalLongPos].value];
         if (!this.inQuadrangle(location,this.context.quadrangle)) {
            continue;
         }
         var date = this.context.columns[internalDateTimePos].value;
         if (date==null) {
            continue;
         }
         if (date.getTime()<startTime || date.getTime()>endTime) {
            continue;
         }
         var dataitem = [];
         for (var f=3; f<this.context.columns.length; f++) {
            dataitem.push(this.context.columns[f].value);
         }
         
         dataset.push(dataitem);
      }
   }
   this.context.data.push(this.mapper(dataset));
   
   this.log("mapped",table.ownerDocument.baseURI);

}

MapReduce.prototype.reduce = function() {
   this.log("reduce");
   if (!this.context.finished && this.context.reduction.length==0) {
      var start = new Date();
      this.context.reduction = this.reducer(this.context.data);
      this.reduceTime = (new Date()).getTime()-start.getTime();
      this.elapsedTime = (new Date()).getTime() - this.startedAt.getTime();
   }
   if (!this.context.finished && this.onComplete) {
      var app = this;
      setTimeout(function() {
         app.log("complete");
         app.onComplete();
      },1);
   }
   this.context.finished = true;
}