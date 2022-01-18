#!/usr/bin/python3

import dearpygui.dearpygui as dpg
import sys
import time

dpg.create_context()

def user_choice(sender, app_data, user_data):
    """user_choice will take the return statement of the choice the user picked
    and return an int which relates to a time zone
    23: EST
    24: CST
    25: MTN
    26: PST
    27: GMT"""
    with dpg.window(label="Time Zone", pos=(200, 150), width=375, height=200):
        dpg.add_text(f"Thank you for Choosing {user_data}, \n\nIf this was made in error \nplease contact itsupport@ for assistance")
    print(sender)
    time.sleep(2)
    sys.exit(1)

with dpg.window(label="Time Zone", pos=(100, 80), width=600, height=400):
    dpg.add_text("Choose your Time Zone")
    dpg.add_button(label="Americas/New York", callback=user_choice, user_data="EST")
    dpg.add_button(label="Americas/Chicago", callback=user_choice, user_data="CST")
    dpg.add_button(label="Americas/Denver", callback=user_choice, user_data="MTN")
    dpg.add_button(label="Americas/San Francisco", callback=user_choice, user_data="PST")
    dpg.add_button(label="GMT", callback=user_choice, user_data="GMT")
    
# this statement does most of the theming
with dpg.theme() as global_theme:
    with dpg.theme_component(dpg.mvAll):
        dpg.add_theme_style(dpg.mvStyleVar_FrameRounding, 5, category=dpg.mvThemeCat_Core)
        dpg.add_theme_style(dpg.mvStyleVar_WindowTitleAlign, 0.50, category=dpg.mvThemeCat_Core)
        dpg.add_theme_style(dpg.mvStyleVar_WindowPadding, 10, category=dpg.mvThemeCat_Core)

dpg.bind_theme(global_theme)


dpg.create_viewport(title="Custom Title", width=800, height=600)
dpg.setup_dearpygui()
dpg.show_viewport()
dpg.start_dearpygui()
dpg.destroy_context()





#TODO:
# 1. center window ✓
# 2. bigger font
# 3. change design/font ✓
# 4. take user_data input and return it ✓
