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

* `FloatLayout`: this layout occupied a space as normal `Widget` or `GridLayout` and its children can only place within this space. The only information to arrange children of `FloatLayout` is `pos` which specify the bottom-left position of each child. If the size of the child is not specify, it will take the space from its position up and to the right until reaching the layout border.

### Custom an UI control
* Examples: https://programmer.help/blogs/implementation-of-hover-event-in-kivy-control.html
* Note:
   * Not declare the inheritance in kv lang but in the Python code if some attributes/events are implement in Python code
   * Include the Python class of the control to the python file of the target layout if the custom control is used in kv lang

### Make a flat button with option of using icon
```kv
<FlatButton>:
    background_color: 0., 0., 0., 0. # --> Make the button transparent
    source: ''
    canvas.before:
        Color:
            rgba: 0, 0.737, 0.831, 1  # --> Set button background color
        Line:
            width: 1
            rectangle: self.x, self.y, self.width, self.height
    Image:
        opacity: 0.0 if self.source == '' else 1.0 # --> Make the icon invisible if there is no image source given
        size_hint_x: None
        width: 20
        size_hint_y: None
        height: self.parent.height
        source: root.source
        center_x: self.parent.center_x
        center_y: self.parent.center_y
```

### Bind a function to an event of a child widget

When create a custom group of widgets, we have to pass values and event function binding to corresponding children's field.

For example: create a group which include a CheckBox and a Label

```kv
MCheckBox:
   m_text: 'Option 0'   #--> value pass to the Label
   m_on_active: root.on_checkbox_active      #--> event binding function pass to the CheckBox
   m_value: 2     #--> value for a custom field of a group

<MCheckBox@GridLayout>:
    cols: 2
    m_text: ''
    m_on_active: None
    m_value: 0
    CheckBox:
        size_hint_x: 0.3
        on_active: root.m_on_active(root.m_value, self.active)  #--> get the function from parent; call and pass values required here
    MLabel:
        size_hint_x: 0.7
        text: root.m_text  #--> get text from parent

```

