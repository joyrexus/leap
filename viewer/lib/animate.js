// Generated by CoffeeScript 1.6.3
(function() {
  var moveTo, offset, root;

  root = typeof exports !== "undefined" && exports !== null ? exports : this;

  offset = 300;

  moveTo = function(pos) {
    var x, y, z;
    x = pos.x, y = pos.y, z = pos.z;
    if (x && y) {
      this.style.visibility = 'visible';
      this.cx.baseVal.value = x + offset;
      this.cy.baseVal.value = y;
      return this.r.baseVal.value = 25 + z / 10;
    } else {
      return this.style.visibility = 'hidden';
    }
  };

  left.moveTo = moveTo;

  right.moveTo = moveTo;

  root.animate = function(data) {
    var i, run;
    hands.style.visibility = 'visible';
    i = 0;
    run = function() {
      var d;
      window.requestAnimationFrame(run);
      if (i < data.length) {
        d = data[i];
        left.moveTo(d.data('left'));
        right.moveTo(d.data('right'));
        return i += 1;
      }
    };
    return run();
  };

}).call(this);