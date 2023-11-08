# Godot Debug Demo for: ObjectDB instances / 'N18RendererCanvasCull4ItemE' leaked at exit

## Error logs

> ERROR: 1 RID allocations of type 'N18RendererCanvasCull4ItemE' were leaked at exit.
> WARNING: ObjectDB instances leaked at exit (run with --verbose for details).
>     at: cleanup (core/object/object.cpp:2207)
> Leaked instance: Node2D:54696855191221058 - Node name: Node2D
> Leaked instance: SceneState:-9168677380686810297
> Hint: Leaked instances typically happen when nodes are removed from the scene tree (with `remove_child()`) but not freed (with `free()` or `queue_free()`).

## To reproduce

Have Nix installed, run: `nix build` (will build and show export logs)

Command executed is at `empty.nix:78`:

> godot4 --path . --headless --verbose --export-release "Linux/X11" $out/bin/empty

I have tested several Godot 4 versions error logs are consistent. Now I'm tracking master because I want to see if something new will fix this.

