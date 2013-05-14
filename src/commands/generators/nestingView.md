## generate nestingView

    diorama generate nestingView <ParentViewName> <ChildViewName>

Generates a new
[Backbone.Diorama.NestingView](https://github.com/th3james/BackboneDiorama/blob/master/src/lib/diorama_nesting_view.md)
and child Backbone.View. ParentViewName specifies the NestingView name,
ChildViewName species the child view to be rendered inside parent.
Generated files are printed in a format suitable for inserting into the
src/compile_manifest.json
