
function AnimateContainer(container,title) {
   this.container = container;
   this.title = title;
   this.animate = false;
   this.interval = 500;
   this.displayType = "block";
}

AnimateContainer.prototype.reset = function() 
{
   this.sequence = [];
   var current = this.container.firstElementChild;
   while (current) {
      this.sequence.push(current);
      current = current.nextElementSibling;
   }
   this.index = this.sequence.length-1;
   
}

AnimateContainer.prototype.start = function() {
   if (this.animate) {
      return;
   }
   this.animate = true;
   var app = this;
   this.animationID = setInterval(function() {
      if (!app.animate) {
         return;
      }
      app.sequence[app.index].style.display = "none";
      app.index++;
      if (app.index>=app.sequence.length) {
         app.index = 0;
      }
      app.sequence[app.index].style.display = app.displayType;
      app.title.innerHTML = app.sequence[app.index].getAttribute("title");
   },this.interval);
   
}

AnimateContainer.prototype.stop = function() {
   if (this.animate) {
      clearInterval(this.animationID);
   }
   this.animate = false;
}
