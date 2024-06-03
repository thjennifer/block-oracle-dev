include: "/views/test/test_view.view"
include: "/views/test/test_view_to_extend.view"

view: +test_view {
extends: [test_view_to_extend]
   }
