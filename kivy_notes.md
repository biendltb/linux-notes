## Tips
* Try to use `size_hint` for direct child components of a main layout to ensure the scalable of the application to any size of screen.
* If one element in a layout set `size_hint_x` or `size_hint_y`, the items in the same column or rows should set to ensure the correct ratio. Kivy will sum all the values and divide it proportionally. Note: `size_hint_x` and `size_hint_y` is 1 if unset.
* If you must set size for a child component of a main layout while still want to maintain the equal-spacing (e.g. set `height` for an element of a vertical `BoxLayout`), it should be wrap in a layout (e.g. `GridLayout`).
* To avoid the content of a layout crushed due to a too small window size, set `size_hint_min_x` in pixels.
* Custom widget declared in a separate file usually have an issue with its width/height which lead to the space between rows/cols not automatically filled. Two common ways to fix it or they could be used together:
    * If the two items won't fit in two consecutive rows/cols, a place holder widget could be place between them as an extra row.
    * By set the layout in the imported file with:
        ```kv
        width: root.width
        size_hint_x: None
        ```
