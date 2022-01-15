import dearpygui.dearpygui as dpg

dpg.create_context()

def user_choice(sender, app_data, user_data):
    sender = sender
    app_data = app_data
    with dpg.window(label="Time Zone"):
        dpg.add_text(f"Thank you for Choosing {user_data}, \n\nif this was made in error \nplease contact itsupport@ for assistance")
     

with dpg.window(label="Time Zone", width=600, height=400):
    dpg.add_text("Choose your Time Zone")
    dpg.add_button(label="Americas/New York", callback=user_choice, user_data="EST")
    dpg.add_button(label="Americas/Chicago", callback=user_choice, user_data="CST")
    dpg.add_button(label="Americas/Denver", callback=user_choice, user_data="MTN")
    dpg.add_button(label="Americas/San Francisco", callback=user_choice, user_data="PST")
    dpg.add_button(label="GMT", callback=user_choice, user_data="GMT")
    

dpg.create_viewport(title="Custom Title", width=800, height=600)
dpg.setup_dearpygui()
dpg.show_viewport()
dpg.start_dearpygui()

dpg.destroy_context()

print("test")