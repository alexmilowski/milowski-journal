function timeToString(ms) {
   if (ms<1000) {
      return ms+"ms";
   } else {
      return Math.round(ms/100)/10+"s";
   }
}
window.addEventListener("load",function() {
   var presets = document.getElementById("preset-regions");
   presets.onchange = function() {
       document.getElementById("region").value = presets.value;
   }
   var duration = 30*60*1000;
   var now = new Date();
   var endDateTime = new Date(now.getTime()-(now.getMinutes()*60*1000)-now.getSeconds()*1000-now.getMilliseconds());
   var startDateTime = new Date(endDateTime.getTime()-duration);
   document.getElementById("start").value = startDateTime.toISOString();
   document.getElementById("duration").value = "30";
   var logOutput = document.getElementById("log");
   var output = document.getElementById("output");
   var log = function(msg) {
      var p = document.createElement("p");
      p.appendChild(document.createTextNode(msg));
      logOutput.appendChild(p);
   }
   var go = document.getElementById("go");
   go.onclick = function() {
      logOutput.innerHTML = "";
      output.innerHTML = "";
      window.barnes = {
         region: JSON.parse(document.getElementById("region").value),
         startDateTime: new Date(document.getElementById("start").value),
         duration: parseInt(document.getElementById("duration").value)*60*1000,
         resolution: parseFloat(document.getElementById("resolution").value),
         min: parseInt(document.getElementById("min").value),
         max: parseInt(document.getElementById("max").value),
         quadsize: parseFloat(document.getElementById("quadsize").value),
         gridavg: new GridAverage("http://www.mesonet.info/data/")
      };
      if (isNaN(barnes.startDateTime.getTime())) {
          alert("Bad start date/time!");
          return;
      }
      barnes.endDateTime = new Date(barnes.startDateTime.getTime()+barnes.duration);
      barnes.gridavg.resolution = barnes.resolution;
      barnes.gridavg.mrlog = function(event,msg) {
         if (event=="request") {
            log("⇒ "+msg);
         } else if (event=="load") {
            log("⇐ "+msg);
         } else if (event=="complete") {
            log("Data Finished.");
         }
      }
      barnes.gridavg.onComplete = function(grid) {
         log("Interpolating...");
          setTimeout(function() {
             for (var i=0; i<grid.length; i++) {
                for (var j=0; j<grid[i].length; j++) {
                   grid[i][j].position = [ barnes.region[0]-j*barnes.resolution, barnes.region[1]+i*barnes.resolution];
                }
             }
             var interpolator = new BarnesInterpolation();
             interpolator.interpolate(grid);
             log("Interpolation finished.");
             var heatmapper = new HeatMap(500,500);
             barnes.url = heatmapper.render(grid,barnes.min,barnes.max,function(cell) { return cell.e});
             var img = document.createElement("img");
             img.setAttribute("src",barnes.url);
             output.appendChild(img);
             var end = new Date();
             log("Elapsed: "+timeToString(end.getTime()-barnes.processStart.getTime()));
             
             var mapButton = document.createElement("button");
             mapButton.innerHTML = "View on Map";
             output.appendChild(mapButton);
             mapButton.onclick = function() {
                output.innerHTML = "<div id='map'/>"; 
                var map = L.map(output.firstChild, { attributionControl: false});
                L.tileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                   attribution: 'Map data © OpenStreetMap contributors',
                   minZoom: 1, MaxZoom: 18
                }).addTo(map);
                var qarea = [[barnes.region[0],barnes.region[1]],[barnes.region[2],barnes.region[3]]];
                map.fitBounds(qarea);
                var zoom = map.getBoundsZoom(qarea,false);
                map.setZoom(zoom);
                var quadLayer  = L.layerGroup();
                quadLayer.addTo(map);
                var box = L.rectangle(qarea,{fill: false, weight: 1});
                quadLayer.addLayer(box);
                L.imageOverlay(barnes.url,qarea, { opacity: 0.5}).addTo(map);
             };
             go.disabled = false;
          },10);
      } 

      setTimeout(function() {
         go.disabled = true;
         barnes.processStart = new Date();
         barnes.gridavg.apply(barnes.region,barnes.startDateTime,barnes.endDateTime,barnes.quadsize);
      },1);
   }
   
},false);