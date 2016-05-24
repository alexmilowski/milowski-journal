if (typeof(Number.prototype.toRad) === "undefined") {
  Number.prototype.toRad = function() {
    return this * Math.PI / 180;
  }
}

function BarnesInterpolation() {
   this.R = 111.32; // 1 degree in km
   this.C = [ 1, 0.3 ]; // convergence values for passes.  The last will be used for remaining
   this.limit = 3; // iteration limit
   this.tolerance = 1; // tollerance to observed value
   this.spaceEfficient = false;
}

// Haversine formulation: http://www.movable-type.co.uk/scripts/latlong.html
BarnesInterpolation.prototype.D = function(lat1,lon1,lat2,lon2) {
   var R = 6378.1; // km
   var dLat = (lat2-lat1).toRad();
   var dLon = (lon2-lon1).toRad();
   var lat1 = lat1.toRad();
   var lat2 = lat2.toRad();
   
   var a = Math.sin(dLat/2) * Math.sin(dLat/2) +
           Math.sin(dLon/2) * Math.sin(dLon/2) * Math.cos(lat1) * Math.cos(lat2); 
   var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a)); 
   var d = R * c;
   return d;
}

BarnesInterpolation.prototype.interpolate = function(grid) {
   if (this.spaceEfficient) {
      this.interpolateTime(grid);
   } else {
      this.interpolateSpace(grid);
   }
}

BarnesInterpolation.prototype.logElapsed = function(start,msg) {
   var now = new Date();
   console.log(msg+": "+(now.getTime()-start.getTime()));
   return new Date();
}

// expected input: grid (m x n) of objects with "value" and "position" properties
// the default is latitude and longitude but the D() function can be redefined
BarnesInterpolation.prototype.interpolateSpace = function(grid) {

   var clat = grid[0][0].position[0];
   var clon = grid[0][0].position[1];
   var observed = [];
   var distances = [];
   for (var i=0; i<grid.length; i++) {
      for (var j=0; j<grid[i].length; j++) {
         distances.push([]);
         if (!isNaN(grid[i][j].value)) {
            observed.push({ position: [ i, j], value: grid[i][j].value });
         }
         var d = this.D(clat,clon,grid[i][j].position[0],grid[i][j].position[1]);
         distances[i].push(d);
      }
   }
   
   // pass 0: initial weighted sum
   for (var i=0; i<grid.length; i++) {
      for (var j=0; j<grid[i].length; j++) {
         var osum = 0;
         var wsum = 0;
         for (var o=0; o<observed.length; o++) {
            var oi = observed[o].position[0];
            var oj = observed[o].position[1]
            var x = i<oi ? oi-i : i-oi;
            var y = j<oj ? oj-j : j-oj;
            var d = distances[x][y];
            var w = Math.exp(-1*Math.pow(d/this.R,2)/this.C[0]);
            osum += w*observed[o].value;
            wsum += w;
         }
         grid[i][j].e = osum/wsum;
      }
   }

   // pass 1 through N
   var converged = false;
   for (var pass=1; !converged && pass<this.limit; pass++) {
      var cindex = pass>=this.C.length ? this.C.length-1 : pass;
   
      // compute subsequent estimated values from errors from past value
      for (var i=0; i<grid.length; i++) {
         for (var j=0; j<grid[i].length; j++) {
            var osum = 0;
            var wsum = 0;
            for (var o=0; o<observed.length; o++) {
               var oi = observed[o].position[0];
               var oj = observed[o].position[1]
               var x = i<oi ? oi-i : i-oi;
               var y = j<oj ? oj-j : j-oj;
               var d = distances[x][y];
               var c = this.C[cindex];
               var w = Math.exp(-1*Math.pow(d/this.R,2)/c);
               osum += w*(observed[o].value - grid[i][j].e);
               wsum += w;
            }
            grid[i][j].e = grid[i][j].e + osum/wsum;
         }
      }
      // check for convergence of observed values within the tolerance
      var nearenough = true;
      for (var o=0; o<observed.length; o++) {
         if (Math.abs(observed[o].value-grid[observed[o].position[0]][observed[o].position[1]].value)>this.tolerance) {
            nearenough = false;
         }
      }
      converged = nearenough;
   }
}   

BarnesInterpolation.prototype.interpolateTime = function(grid) {

   var observed = [];
   for (var i=0; i<grid.length; i++) {
      for (var j=0; j<grid[i].length; j++) {
         if (isNaN(grid[i][j].value)) {
            continue;
         }
         observed.push({ position: [ i, j], value: grid[i][j].value });
      }
   }
   
   // pass 0: initial weighted sum
   for (var i=0; i<grid.length; i++) {
      for (var j=0; j<grid[i].length; j++) {
         var osum = 0;
         var wsum = 0;
         for (var o=0; o<observed.length; o++) {
            var ocell = grid[observed[o].position[0]][observed[o].position[1]];
            var d = this.D(ocell.position[0],ocell.position[1],grid[i][j].position[0],grid[i][j].position[1]);
            var w = Math.exp(-1*Math.pow(d/this.R,2)/this.C[0]);
            osum += w*observed[o].value;
            wsum += w;
         }
         grid[i][j].e = osum/wsum;
      }
   }

   // pass 1 through N
   var converged = false;
   for (var pass=1; !converged && pass<this.limit; pass++) {
      var cindex = pass>=this.C.length ? this.C.length-1 : pass;
      // compute subsequent estimated values from errors from past value
      for (var i=0; i<grid.length; i++) {
         for (var j=0; j<grid[i].length; j++) {
            var osum = 0;
            var wsum = 0;
            for (var o=0; o<observed.length; o++) {
               var ocell = grid[observed[o].position[0]][observed[o].position[1]];
               var d = this.D(ocell.position[0],ocell.position[1],grid[i][j].position[0],grid[i][j].position[1]);
               var c = this.C[cindex];
               var w = Math.exp(-1*Math.pow(d/this.R,2)/c);
               osum += w*(observed[o].value - grid[i][j].e);
               wsum += w;
            }
            grid[i][j].e = grid[i][j].e + osum/wsum;
         }
      }
      // check for convergence of observed values within the tolerance
      var nearenough = true;
      for (var o=0; o<observed.length; o++) {
         if (Math.abs(observed[o].value-grid[observed[o].position[0]][observed[o].position[1]].value)>this.tolerance) {
            nearenough = false;
         }
      }
      converged = nearenough;
   }
}   
