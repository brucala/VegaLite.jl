######################################################################
#
#     Default plotting using browser tab
#
######################################################################

type VLPlot
  json::String
end

asset(url...) = normpath(joinpath(dirname(@__FILE__), "..", "deps", "lib", url...))

#Vega Scaffold: https://github.com/vega/vega/wiki/Runtime
function writehtml(io::IO, v::VLPlot; title="VegaLite plot")
  divid = "vg" * randstring(3)

  println(io,
  """
  <html>
    <head>
      <title>$title</title>
      <meta charset="UTF-8">
      <script src="file://$(asset("d3.v3.min.js"))"></script>
      <script src="file://$(asset("vega.min.js"))"></script>
      <script src="file://$(asset("vega-lite.min.js"))"></script>
      <script src="file://$(asset("vega-embed.min.js"))"></script>
    </head>
    <body>
      <div id="$divid"></div>
    </body>

    <style media="screen">
      .vega-actions a {
        margin-right: 10px;
        font-family: sans-serif;
        font-size: x-small;
        font-style: italic;
      }
    </style>

    <script type="text/javascript">

      var opt = {
        mode: "vega-lite",
        renderer: "$RENDERER",
        actions: $ACTIONSLINKS
      }

      var spec = $(v.json)

      vega.embed('#$divid', spec, opt);

    </script>

  </html>
  """)
end
#
# function writehtml(io::IO, v::VLPlot; title="VegaLite plot")
#   divid = "vg" * randstring(3)
#
#   println(io,
#   """
#   <html>
#     <head>
#       <title>$title</title>
#       <meta charset="UTF-8">
#     </head>
#
#     <body>
#       <div id="$divid"></div>
#     </body>
#
#     <style media="screen">
#       .vega-actions a {
#         margin-right: 10px;
#         font-family: sans-serif;
#         font-size: x-small;
#         font-style: italic;
#       }
#     </style>
#
#     <script type="text/javascript">
#
#     requirejs.config({
#         paths: {
#           d3: "file://$(asset("d3.v3.min.js"))",
#           vg: "file://$(asset("vega.min.js"))",
#           vl: "file://$(asset("vega-lite.min.js"))",
#           vg_embed: "file://$(asset("vega-embed.min.js"))"
#         },
#         shim: {
#           vg_embed: {deps: ["vg.global", "vl.global"]},
#           vl: {deps: ["vg"]},
#           vg: {deps: ["d3"]}
#         }
#     });
#
#     define('vg.global', ['vg'], function(vgGlobal) {
#         window.vg = vgGlobal;
#     });
#
#     define('vl.global', ['vl'], function(vlGlobal) {
#         window.vl = vlGlobal;
#     });
#
#     require(["vg_embed"], function(vg_embed) {
# //      var vlSpec = $(JSON.json(v.vis));
#
# //      var embedSpec = {
# //        mode: "vega-lite",
# //        renderer: "$(SVG ? "svg" : "canvas")",
# //        actions: $SAVE_BUTTONS,
# //        spec: vlSpec
# //      };
# //
# //      vg_embed("#$divid", embedSpec, function(error, result) {});
#
#       var opt = {
#         mode: "vega-lite",
#         renderer: "$RENDERER",
#         actions: $ACTIONSLINKS
#       }
#
#       var spec = $(v.json)
#
#       vega.embed('#$divid', spec, opt);
#     })
#
#
#
#
#
#     </script>
#
#   </html>
#   """)
# end



import Base.show

function show(io::IO, v::VLPlot)
  # if displayable("text/html")
  #   println("plotting as html")
  #   writehtml(io,v)
  # else
    # create a temporary file
    tmppath = string(tempname(), ".vegalite.html")
    io = open(tmppath, "w")
    writehtml(io, v)
    close(io)

    # println("show :")
    # Base.show_backtrace(STDOUT, backtrace())
    # println()

    # Open the browser
    @static if VERSION < v"0.5.0-"
      @osx_only run(`open $tmppath`)
      @windows_only run(`cmd /c start $tmppath`)
      @linux_only   run(`xdg-open $tmppath`)
    else
      if is_apple()
        run(`open $tmppath`)
      elseif is_windows()
        run(`cmd /c start $tmppath`)
      elseif is_linux()
        run(`xdg-open $tmppath`)
      end
    end

  # end

  return
end


# function show(io::IO, m::MIME"text/html", v::VLPlot)
#   writehtml(io, v)
# end





import Atom, Media

function Media.render(e::Atom.Editor, plt::VLPlot)
  Media.render(e, nothing)
  println("hello")
  show(plt)
end
