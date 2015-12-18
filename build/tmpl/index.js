function index_tmpl(locals) {
var buf = [];
var jade_mixins = {};
var jade_interp;
;var locals_for_with = (locals || {});(function (pageTitle, ship_list, undefined) {
buf.push("<!DOCTYPE html><html lang=\"en\"><head><title>" + (jade.escape(null == (jade_interp = pageTitle) ? "" : jade_interp)) + "</title><link rel=\"stylesheet\" href=\"bower_components/xwing-miniatures-font/dist/xwing-miniatures.css\"><link rel=\"stylesheet\" href=\"build/css/ai.css\"><script src=\"bower_components/jquery/dist/jquery.js\"></script><script src=\"build/js/hotac_data.js\"></script></head><body>");
// iterate ship_list
;(function(){
  var $$obj = ship_list;
  if ('number' == typeof $$obj.length) {

    for (var $index = 0, $$l = $$obj.length; $index < $$l; $index++) {
      var ship_str = $$obj[$index];

buf.push("<div" + (jade.attr("id", "ai-" + (ship_str) + "", true, true)) + " class=\"ai\"><table><tr><td class=\"far aheadleft display\"><i></i><span></span></td><td class=\"far aheadleft\"></td><td class=\"far ahead display\"><i></i><span></span></td><td class=\"far aheadright\"></td><td class=\"far aheadright display\"><i></i><span></span></td></tr><tr><td class=\"far aheadleft\"></td><td class=\"near aheadleft display\"><i></i><span></span></td><td class=\"near ahead display\"><i></i><span></span></td><td class=\"near aheadright display\"><i></i><span></span></td><td class=\"far aheadright\"></td></tr><tr><td class=\"far flankleft display\"><i></i><span></span></td><td class=\"near flankleft display\"><i></i><span></span></td><td class=\"displayship\"><i></i></td><td class=\"near flankright display\"><i></i><span></span></td><td class=\"far flankright display\"><i></i><span></span></td></tr><tr><td class=\"far behindleft\"></td><td class=\"near behindleft display\"><i></i><span></span></td><td class=\"near behind display\"><i></i><span></span></td><td class=\"near behindright display\"><i></i><span></span></td><td class=\"far behindright\"></td></tr><tr><td class=\"far behindleft display\"><i></i><span></span></td><td class=\"far behindleft\"></td><td class=\"far behind\"></td><td class=\"far behindright\"></td><td class=\"far behindright display\"><i></i><span></span></td></tr></table></div><script>var " + (jade.escape((jade_interp = ship_str) == null ? '' : jade_interp)) + "_instance = new window.shipAi[\"" + (jade.escape((jade_interp = ship_str) == null ? '' : jade_interp)) + "\"]()\n" + (jade.escape((jade_interp = ship_str) == null ? '' : jade_interp)) + "_instance.initDom(\"ai-" + (jade.escape((jade_interp = ship_str) == null ? '' : jade_interp)) + "\")</script>");
    }

  } else {
    var $$l = 0;
    for (var $index in $$obj) {
      $$l++;      var ship_str = $$obj[$index];

buf.push("<div" + (jade.attr("id", "ai-" + (ship_str) + "", true, true)) + " class=\"ai\"><table><tr><td class=\"far aheadleft display\"><i></i><span></span></td><td class=\"far aheadleft\"></td><td class=\"far ahead display\"><i></i><span></span></td><td class=\"far aheadright\"></td><td class=\"far aheadright display\"><i></i><span></span></td></tr><tr><td class=\"far aheadleft\"></td><td class=\"near aheadleft display\"><i></i><span></span></td><td class=\"near ahead display\"><i></i><span></span></td><td class=\"near aheadright display\"><i></i><span></span></td><td class=\"far aheadright\"></td></tr><tr><td class=\"far flankleft display\"><i></i><span></span></td><td class=\"near flankleft display\"><i></i><span></span></td><td class=\"displayship\"><i></i></td><td class=\"near flankright display\"><i></i><span></span></td><td class=\"far flankright display\"><i></i><span></span></td></tr><tr><td class=\"far behindleft\"></td><td class=\"near behindleft display\"><i></i><span></span></td><td class=\"near behind display\"><i></i><span></span></td><td class=\"near behindright display\"><i></i><span></span></td><td class=\"far behindright\"></td></tr><tr><td class=\"far behindleft display\"><i></i><span></span></td><td class=\"far behindleft\"></td><td class=\"far behind\"></td><td class=\"far behindright\"></td><td class=\"far behindright display\"><i></i><span></span></td></tr></table></div><script>var " + (jade.escape((jade_interp = ship_str) == null ? '' : jade_interp)) + "_instance = new window.shipAi[\"" + (jade.escape((jade_interp = ship_str) == null ? '' : jade_interp)) + "\"]()\n" + (jade.escape((jade_interp = ship_str) == null ? '' : jade_interp)) + "_instance.initDom(\"ai-" + (jade.escape((jade_interp = ship_str) == null ? '' : jade_interp)) + "\")</script>");
    }

  }
}).call(this);

buf.push("</body></html>");}.call(this,"pageTitle" in locals_for_with?locals_for_with.pageTitle:typeof pageTitle!=="undefined"?pageTitle:undefined,"ship_list" in locals_for_with?locals_for_with.ship_list:typeof ship_list!=="undefined"?ship_list:undefined,"undefined" in locals_for_with?locals_for_with.undefined:typeof undefined!=="undefined"?undefined:undefined));;return buf.join("");
}