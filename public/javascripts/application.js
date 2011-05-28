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
				var line = this.add_polyline();
  			var listener = google.maps.event.addListener(this.canvas, 'click', function(event){
  				_this.add_poly_point(event, line);
  			});
  			this.listeners.push(listener);	
		}
	}
	
	this.add_marker = function(location){
		this.markers.push( new google.maps.Marker({position: location, map: this.canvas}) );
	}
	
	this.add_polyline = function(){
		this.polylines.unshift( new google.maps.Polyline(this.poly_options) );
  	this.polylines[0].setMap(this.canvas);
  	return this.polylines[0];
	}
	
	this.add_poly_point = function(event, polyline){
	  var path = polyline.getPath();
	  console.log(event.latLng);
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
	// create a json in the format
	// { marker: [{marker1, marker2..}], polyline: [{poly1, poly2..}]}
	this.serialize = function(){
		var serialized = {};
		var marker_list = [];
		var polyline_list = [];
		var coord_list = [];
		
		this.markers.forEach(function(marker){		
			marker_list.push({ lat: marker.getPosition().lat().toString(),
												 lng: marker.getPosition().lng().toString()});
		});
		
		this.polylines.forEach(function(polyline){
			var coords = polyline.getPath().getArray();
			coords.forEach(function(coord){
				coord_list.push({lat: coord.lat().toString(), lng: coord.lng().toString()});
			});
			polyline_list.push(coord_list);
		});
		
		serialized['polyline'] = polyline_list;
		serialized['marker'] = marker_list;	
		return $.serializeJSON(serialized);
	}
	
	// show_overlay will take the json version of markers/polylines
	// and draw them on the map
	this.show_overlay = function(overlay){;
		var _this = this;
		
		overlay.marker.forEach(function(marker){
				var latlng = new google.maps.LatLng(marker.lat, marker.lng);
				_this.add_marker(latlng);
		});
		
		overlay.polyline.forEach(function(polyline){
			var line = _this.add_polyline();
			polyline.forEach(function(coord){
				var latlng = new google.maps.LatLng(coord.lat, coord.lng);
				// need to pass ing {latLng: latlng} here, as this is what google.maps.Marker expects
				_this.add_poly_point({latLng: latlng}, line);
			});
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
