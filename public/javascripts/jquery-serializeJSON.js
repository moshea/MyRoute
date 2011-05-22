jQuery(function($) {
    $.extend({
        serializeJSON: function(obj) {
            var t = typeof(obj);
            if(t != "object" || obj === null) {
                // simple data type
                if(t == "string") obj = '"' + obj + '"';
                return String(obj);
            } else {
                // array or object
                var json = [], arr = (obj && obj.constructor == Array);
 
                $.each(obj, function(k, v) {
                    t = typeof(v);
                    if(t == "string") v = '"' + v + '"';
                    else if (t == "object" & v !== null) v = $.serializeJSON(v)
                    json.push((arr ? "" : '"' + k + '":') + String(v));
                });
 
                return (arr ? "[" : "{") + String(json) + (arr ? "]" : "}");
            }
        }
    });
});