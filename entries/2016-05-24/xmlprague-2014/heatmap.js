function HeatMap(width,height)
{
   this.container = document.body;
   this.width = width;
   this.height = height;
   this.canvas = null;
}

HeatMap.prototype.render = function(grid,min,max,accessor) {
   var dimX = grid.length;
   var dimY = grid[0].length;
   var sizeY = Math.floor(this.height / dimY);
   var boxSizeY = Math.ceil(this.height / dimY);
   var errorY = this.height / dimY - sizeY;
   var sizeX = Math.floor(this.width / dimX);
   var boxSizeX = Math.ceil(this.width / dimX)
   var errorX = this.width / dimX  - sizeX;

   if (!this.canvas) {
      var canvas = document.createElement("canvas");
      canvas.setAttribute("height",this.height.toString());
      canvas.setAttribute("width",this.width.toString());
      this.container.appendChild(canvas);
   }
   var context = this.canvas ? this.canvas.getContext('2d') : canvas.getContext('2d');
   context.clearRect(0,0,this.width,this.height);

   var accErrorX = 0;
   for (var i=0; i<grid.length; i++) {
      accErrorX += errorX;
      var adjX = Math.floor(accErrorX);
      var accErrorY = 0;
      for (var j=0; j<grid[i].length; j++) {
         accErrorY += errorY;      
         var adjY = Math.floor(accErrorY);
         var color = this.color(min,max,accessor ? accessor(grid[i][j]) : grid[i][j]);
         context.fillStyle = "rgb("+color[0]+","+color[1]+","+color[2]+")";
         context.fillRect(i*sizeX+Math.floor(accErrorX),j*sizeY+Math.floor(accErrorY),boxSizeX,boxSizeY);
      }
   }
   if (!this.canvas) {
      this.container.removeChild(canvas);
   }
      
   return this.canvas ? null : canvas.toDataURL();
}

// from http://stackoverflow.com/questions/2374959/algorithm-to-convert-any-positive-integer-to-an-rgb-value
HeatMap.prototype.color = function(min,max,value) {
   var minWavelength = 350;
   var maxWavelength = 750;
   if (value<min) {
      value = min;
   } else if (value>max) {
      value = max;
   }
   if (min<0) {
      max += -min;
      value += -min;
      min = 0;
   }
   var wavelength = Math.round((value - min) / (max - min) * (maxWavelength - minWavelength) + minWavelength);
   var adjust = function(color,factor) {
      return color==0 ? 0 : Math.round(255*Math.pow(color*factor,0.8));
   };
   var factor = 0;
   if (wavelength>=350 && wavelength<420) {
      factor = 0.3 + 0.7*(wavelength - 350) / (420 - 350);
   } else if (wavelength>=420 && wavelength<701) {
      factor = 1;
   } else if (wavelength>=701) {
      factor = 0.3 + 0.7*(780 - wavelength) / (780 - 700)
   }
   if (wavelength>=350 && wavelength<440) {
      return [ adjust(-(wavelength - 440) / (440 - 350),factor), 0, adjust(1,factor) ];
   } else if (wavelength>=440 && wavelength<490) {
      return [ 0, adjust((wavelength - 440) / (490 - 440),factor), adjust(1,factor) ];
   } else if (wavelength>=490 && wavelength<510) {
      return [ 0, adjust(1,factor), adjust(-(wavelength - 510) / (510 - 490),factor) ];
   } else if (wavelength>=510 && wavelength<580) {
      return [ adjust((wavelength - 510) / (580 - 510),factor), adjust(1,factor), 0 ];
   } else if (wavelength>=580 && wavelength<645) {
      return [ adjust(1,factor), adjust(-(wavelength - 645) / (645 - 580),factor), 0 ];
   } else if (wavelength>=645 && wavelength<780) {
      return [ adjust(1,factor), 0, 0 ];
   }
   return [0,0,0];
}