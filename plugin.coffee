# Note that when compiling with coffeescript, the plugin is wrapped in another
# anonymous function. We do not need to pass in undefined as well, since
# coffeescript uses (void 0) instead.
do ($ = jQuery, window, document) ->

# window and document are passed through as local variable rather than global
# as this (slightly) quickens the resolution process and can be more efficiently
# minified (especially when both are regularly referenced in your plugin).

# Create the defaults once
  pluginName = "debugTools"
  #  overlayElementClass = "debug-tools-overlay"

  debugToolsParentElementCss = """
.debug-show-tools {
  display: -ms-flexbox;
  display: -webkit-flex;
  display: flex;
  -webkit-flex-direction: column-reverse;
  -ms-flex-direction: column-reverse;
  flex-direction: column-reverse;
  -webkit-flex-wrap: nowrap;
  -ms-flex-wrap: nowrap;
  flex-wrap: nowrap;
  -webkit-justify-content: flex-start;
  -ms-flex-pack: start;
  justify-content: flex-start;
  -webkit-align-content: stretch;
  -ms-flex-line-pack: stretch;
  align-content: stretch;
  -webkit-align-items: stretch;
  -ms-flex-align: stretch;
  align-items: stretch;
  width: 80px;
  height: 50px;
  font-size: 14px;
  font-weight: bold;
  z-index: 1500;
  position: fixed;
  right: 13px;
  bottom: 10px;
}
.debug-show-tools ul {
  list-style: none;
  margin-bottom: 0;
}
.debug-show-tools ul li {
  visibility: hidden;
  -webkit-transition: background-color 400ms, color 400ms, -webkit-transform 400ms;
  transition: background-color 400ms, color 400ms, transform 400ms;
  padding: 5px 8px;
}
.debug-show-tools ul li a {
  color: #fff;
  text-decoration: none;
  text-align: center;
  background-color: #0083ae;
  -webkit-border-radius: 20px;
  -moz-border-radius: 20px;
  border-radius: 20px;
  display: block;
  font-weight: bold;
}
.debug-show-tools ul li a:hover {
  color: #e6e6e6;
  background-color: #005d7b;
}
.debug-show-tools ul li a:visited,
.debug-show-tools ul li a:link {
  text-decoration: none;
}
.debug-tools-overlay {
  position: fixed;
  right: 10px;
  bottom: 38px;
  height: 100px;
  width: 170px;
  z-index: 1500;
  font-size: 12px;
  display: -ms-flexbox;
  display: -webkit-flex;
  display: flex;
  -webkit-flex-direction: column-reverse;
  -ms-flex-direction: column-reverse;
  flex-direction: column-reverse;
  -webkit-flex-wrap: nowrap;
  -ms-flex-wrap: nowrap;
  flex-wrap: nowrap;
  -webkit-justify-content: flex-start;
  -ms-flex-pack: start;
  justify-content: flex-start;
  -webkit-align-content: stretch;
  -ms-flex-line-pack: stretch;
  align-content: stretch;
  -webkit-align-items: stretch;
  -ms-flex-align: stretch;
  align-items: stretch;
}
.debug-tools-overlay ul {
  list-style: none;
}
.debug-tools-overlay ul li {
  visibility: hidden;
  margin-bottom: 5px;
  float: none;
  padding: 0 5px;
  -webkit-transition: background-color 400ms, color 400ms, -webkit-transform 400ms;
  transition: background-color 400ms, color 400ms, transform 400ms;
}
.debug-tools-overlay ul li a {
  color: #fff;
  text-decoration: none;
  text-align: center;
  background-color: #0083ae;
  -webkit-border-radius: 15px;
  -moz-border-radius: 15px;
  border-radius: 15px;
  display: block;
  padding: 5px 8px;
}
.debug-tools-overlay ul li a:hover {
  color: #e6e6e6;
  background-color: #007095;
}
.debug-tools-overlay ul li a:visited,
.debug-tools-overlay ul li a:link {
  text-decoration: none;
}
.debug-tools-overlay ul li:hover {
  color: #f2f2f2;
}

"""

  debugToolsParentElementHtml = """
<div class="debug-tools-overlay">
<ul>
  <li><a href="#" class="debug-tool" data-debug-tool="outline">Outline Elements</a></li>
  <li><a href="#" class="debug-tool" data-debug-tool="hide">Tools</a></li>
</ul>

</div>
"""

  debugToolsShowParentElementHtml = """
<div class="debug-show-tools">
<ul>
<li>
<a href="#" class="debug-toggle-display">*-*</a>
</li>
</ul>
</div>"""

  outlineElementsCss = """
<style type='text/css' id='debug-tools-element-outline'>
* {
    outline: 1px solid red;
}
</style>
"""

  defaults =
#    drawElementDisplay: true
#    outlineElements: false
    outlineOptions:
      color: 'red'
      size: '1px'
      style: 'solid'


  # The actual plugin constructor
  class PluginDebugTools
    constructor: (@element, options) ->
# jQuery has an extend method which merges the contents of two or
# more objects, storing the result in the first object. The first object
# is generally empty as we don't want to alter the default options for
# future instances of the plugin
      @settings = $.extend {}, defaults, options
      @_defaults = defaults
      @_name = pluginName

      @elements_outlined = false

      @init()

    init: ->
      console.log("Init for DebugTools has been called")
      # Bind Events to listen to elements
      @drawElementDisplay("gear")
      return

    drawElementsOutline: ->
      do (plugin = @) ->
        do (outline_tool_element = $('li[data-debug-tool = "outline"] ')) ->
          if $.exists("#debug-tools-element-outline")
            $('#debug-tools-element-outline').remove()
            plugin.elements_outlined = false
            console.log "Removed outline style from head"
            outline_tool_element.css('font-weight', '').text("Outline Elements")
          else
            $('head').append(outlineElementsCss)
            plugin.elements_outlined = true
            console.log("Adding outline to elements")
            outline_tool_element.css('font-weight', 'bold').text("[X] Outline Elements")
          return
      return

    bindShowToolsEvent: ->
      do (plugin = @) ->
        $(".debug-toggle-display").click ->
          console.log("Debug Show Tools Clicked")
          plugin.drawElementDisplay("menu");
          return
        return
      return

    bindMenuToolsEvent: ->
      do (plugin = @) ->
        $(".debug-tool").click ->
          console.log "Debug Tool item has been clicked"
          action = $(@).data("debug-tool")

          if not action?
            console.log("Undefined/Null debug tool defined on element")
            return

          switch action
            when "outline" then plugin.drawElementsOutline()
            when "parent","hide" then plugin.drawElementDisplay("gear")
            else
              console.log("Undefined action for debugging: #{action}")

          return
        return
      return


    drawElementDisplay: (value = "gear") ->
      if not ($("#debug-tools-menu-style").length > 0)
        $.addStyle(debugToolsParentElementCss, "debug-tools-menu-style");
        console.log("Appended CSS Styles to document")

      if value is "gear"
        if ($(".debug-show-tools").length > 0)
          return

        $('body').prepend(debugToolsShowParentElementHtml);

        $('.debug-show-tools ul li').fadeInEach(1000);

        if ($(".debug-tools-overlay").length > 0)
          $(".debug-tools-overlay").fadeOut(500);
          $(".debug-tools-overlay").remove();


        do (plugin = @) ->
          plugin.bindShowToolsEvent()
          return

        console.log "Removed Debug Tools Overlay!, Appended Show-Tools Button"

#        $(".debug-show-tools ul li").fadeInEach(200)
      else
        if not ($(".debug-tools-overlay").length > 0)
          $('body').prepend(debugToolsParentElementHtml)

          #REgister our event for listening!
          do (plugin = @) ->
            plugin.bindMenuToolsEvent()
            return
          # Out of lexical Scope
          console.log("Created Debug Tools Overlay")

        if ($('.debug-show-tools').length > 0)
#Total JQuery hack to filter all visible items and hide them with a fade effect.
          $('.debug-show-tools ul > li').filter(->
            return $(@).css("visibility") is "visible"
          ).css("visibility", "hidden").show().fadeOut(200);

          $('.debug-show-tools').remove();
          console.log("Debug-Show-Tools Removed (After Fade")


        $('.debug-tools-overlay ul > li').fadeInEach(500)
        return


  # some logic

  # A really lightweight plugin wrapper around the constructor,
  # preventing against multiple instantiations
  $.fn[pluginName] = (options) ->
    @each ->
      unless $.data @, "plugin_#{pluginName}"
        $.data @, "plugin_#{pluginName}", new PluginDebugTools @, options
