$(document).ready(function(){
	$('#route_submit').live('click', function(){
		$('#route_gmap_coords').val(map.serialize().toString());
	});

});
