function Map(){
	
	this.canvas = undefined;
	
	this.markers = new Markers();
		
	this.options = {
      zoom: 8,
      center: new google.maps.LatLng(-34.397, 150.644),
      mapTypeId: google.maps.MapTypeId.ROADMAP
    };
	
	this.show_canvas = function(){
		this.canvas = new google.maps.Map(document.getElementById("map_canvas"), this.options);
	}
	
	this.add_marker = function(location){
		var marker = new google.maps.Marker({position: location, map: this.canvas});
		this.markers.push(marker);
		this.markers.serialize();
	}
	
	this.mode = function(mode){
		_this = this;
		switch(mode){
			case "read":
				break;
			case "create":
				google.maps.event.addListener(this.canvas, 'click', function(event){
					_this.add_marker(event.latLng);
				});
				break;
		}
	}
}

function Markers(){
	this.marker_list = [];
	
	this.push = function(marker){
		this.marker_list.push(marker);
	}
	
	this.serialize = function(){
		var list = []
		this.marker_list.forEach(function(marker){
			list.push({ name: "position", "value": marker.getPosition().toString() });
		});
		$('#route_gmap_coords').text($.param(list));
		console.log($.param(list));
	}

}
