include: "/views/test/test_view_ext.view"
include: "/views/test/test_view_to_extend.view"
view: +test_view_ext {
  extends: [test_view_to_extend]

   }
