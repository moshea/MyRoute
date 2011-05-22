function Map(){
	// stores the base google map
	this.canvas = undefined;
	
	this.markers = [];
	
	this.polylines = [];
	
	this.listeners = [];
	
	// initial options for creating the base map
	this.init_options = {
      zoom: 8,
      center: new google.maps.LatLng(-34.397, 150.644),
      mapTypeId: google.maps.MapTypeId.ROADMAP
    }
    
  // initial options for creating a polyline  
  this.poly_options = {
		strokeColor: '#0000ff',
    strokeOpacity: 1.0,
    strokeWeight: 3
  }
  
	// will render the map on screen
	this.show_canvas = function(){
		this.canvas = new google.maps.Map(document.getElementById("map_canvas"), this.init_options);
	}
	
	// setting the mode allows us to read/write polylines and markers
	// clear all other listners then set up new ones
	// modes are: "read", "add_marker", "add_poly"
	this.mode = function(mode){
		var _this = this;
		this.clear_listeners();
		switch(mode){
			case "read":
				break;
			case "add_marker":
				var listener = google.maps.event.addListener(this.canvas, 'click', function(event){
					_this.add_marker(event.latLng);
				});
				this.listeners.push(listener);
				break;
			case "add_poly":
				// using unshift here, so the new poly line is always the first in the polyline array
				// it will reduce computation time for finding the last one
				this.polylines.unshift( new google.maps.Polyline(this.poly_options) );
  			this.polylines[0].setMap(this.canvas);
  			var listener = google.maps.event.addListener(this.canvas, 'click', function(event){
  				_this.add_poly_point(event, _this.polylines[0]);
  			});
  			this.listeners.push(listener);	
		}
	}
	
	this.add_marker = function(location){
		this.markers.push( new google.maps.Marker({position: location, map: this.canvas}) );
	}
	
	this.add_poly_point = function(event, polyline){
	  var path = polyline.getPath();
	  path.push(event.latLng);
	  // Add a new marker at the new plotted point on the polyline.
	  var marker = new google.maps.Marker({
	    position: event.latLng,
	    title: '#' + path.getLength(),
	    map: this.canvas
	  })
	}
	
	// need to do this each time we switch modes
	this.clear_listeners = function(){
		this.listeners.forEach(function(listener){
			google.maps.event.removeListener(listener);
		})
	}
	
	// useful for submitting the map data back to the server
	this.serialize = function(){
		var list = [];
		this.markers.forEach(function(marker){
			list.push({ type: "marker",
									lat: marker.getPosition().lat().toString(),
									lng: marker.getPosition().lng().toString()});
		})
		this.polylines.forEach(function(polyline){
			list.push({path: polyline.getPath().getArray().toString() });
		})
		
		return $.serializeJSON(list);
	}
	
	this.show_overlay = function(overlay){
		var _this = this;
		overlay.forEach(function(marker){
			if(marker.type == "marker"){
				latlng = new google.maps.LatLng(marker.lat, marker.lng);
				_this.add_marker(latlng);
			}
		});
	}
	
	this.get_overlay = function(url){
		var _this = this;
		$.ajax({url:url, type:'GET', 
			success:function(data){ 
					_this.show_overlay(data);	
				}
			});
	}
}
