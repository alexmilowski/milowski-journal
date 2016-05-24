function MapAnimator(container,region,title) {
   this.container = container;
   this.map = L.map(container, { attributionControl: false});
   L.tileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      attribution: 'Map data © OpenStreetMap contributors',
      minZoom: 1, MaxZoom: 18
   }).addTo(this.map);
   var qarea = [[region[0],region[1]],[region[2],region[3]]];
   this.map.fitBounds(qarea);
   var zoom = this.map.getBoundsZoom(qarea,false);
   this.map.setZoom(zoom);
   this.image = new L.ImageOverlay(vortexImages[0].url,qarea, { opacity: 0.5});
   this.image.addTo(this.map);
   this.animating = false;
   this.index = 0;
   this.interval = 250;
   this.title = title;
}

MapAnimator.prototype.start = function() {
   if (this.animating) {
      return;
   }
   this.animating = true;
   var app = this;
   this.animationID = setInterval(function() {
      if (!app.animating) {
         return;
      }
      app.image.setUrl(vortexImages[app.index].url);
      app.title.innerHTML = vortexImages[app.index].title;
      app.index++;
      if (app.index>=vortexImages.length) {
         app.index = 0;
      }
   },this.interval);
   
}

MapAnimator.prototype.stop = function() {
   if (this.animating) {
      clearInterval(this.animationID);
   }
   this.animating = false;
}

window.addEventListener("load",function() {
   
   window.vortexImages = [];
   var animationContainer = document.getElementById("vortex");
   var mapContainer = document.getElementById("map-vortex");
   mapContainer.style.display = "none";
   var heatmapper = new HeatMap(500,500);
   var fetch = function(href) {
      var request = new XMLHttpRequest();
      request.start = new Date();
      request.open("GET",href,true);
      request.onreadystatechange = function() {
         if (request.readyState==4) {
            var dataset = JSON.parse(request.responseText);
            for (var j=0; j<dataset.sequence.length; j++) {
               var url = heatmapper.render(dataset.sequence[j].grid,-20,37);
               vortexImages.push({url: url, title: dataset.sequence[j].start});
            }
            if (vortex.length>0) {
                setTimeout(function() {
                   fetch(vortex.shift());
                },10);
            } else {
               document.getElementById("vortex-status").innerHTML = "";
            }
         }
      };
      request.send();
   };
   fetch(vortex.shift());
   
   var stopStart = document.getElementById("vortex-controller");
   stopStart.onclick = function() {
      if (stopStart.innerHTML=="Stop") {
         animator.stop();
         stopStart.innerHTML = "Simple Animation";
      } else {
         if (typeof animator == "undefined") {
            window.animator = new AnimateContainer(animationContainer,document.getElementById("vortex-title"));
            for (var i=0; i<vortexImages.length; i++) {
               var img = document.createElement("img");
               img.setAttribute("src",vortexImages[i].url);
               img.setAttribute("title",vortexImages[i].title);
               animationContainer.appendChild(img);
            }
            animator.reset();
            animator.interval = 250;
         }
         animationContainer.style.display = "block";
         animator.start();
         stopStart.innerHTML = "Stop";
      }
   }
   var mapStopStart = document.getElementById("vortex-map-controller");
   mapStopStart.onclick = function() {
      if (mapStopStart.innerHTML=="Stop") {
         mapAnimator.stop();
         mapStopStart.innerHTML = "Map Animation";
      } else {
          if (typeof animator != "undefined") {
             animator.stop();
             stopStart.innerHTML = "Simple Animation";
             animationContainer.style.display = "none";
          }
          if (typeof mapAnimator == "undefined") {
              mapContainer.style.display = "block";
              window.mapAnimator = new MapAnimator(mapContainer,[50,-125,25,-65],document.getElementById("vortex-title"));
          }
          mapAnimator.start();
          mapStopStart.innerHTML = "Stop"
      }
   }
    
},false);