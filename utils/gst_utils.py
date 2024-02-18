import cv2
import numpy as np
from IPython.display import display, Image
import ipywidgets as widgets
import threading


# Display function
def view(pipeline, stopButton):
    cap = cv2.VideoCapture(pipeline, cv2.CAP_GSTREAMER)
    if not cap.isOpened():
        raise Exception("Error: Could not open GStreamer pipeline.")
        
    display_handle=display(None, display_id=True)
    
    while True:
        ret , frame = cap.read()
        if not ret:
            print("Error: Could not read frame.")
            cap.release()
            break
            
        _, frame = cv2.imencode('.jpeg', frame)
        display_handle.update(Image(data=frame.tobytes()))
        if stopButton.value==True:
            cap.release()
            display_handle.update(None)
            break

def gst_launch(pipeline_str):
    # Stop button
    stopButton = widgets.ToggleButton(
        value=False,
        description='Stop',
        disabled=False,
        button_style='danger', # 'success', 'info', 'warning', 'danger' or ''
        tooltip='Description',
        icon='square' # (FontAwesome names without the `fa-` prefix)
    )
    display(stopButton)

    # Run the video in a different thread
    thread = threading.Thread(target=view, args=(pipeline_str, stopButton,))
    thread.start()

    return thread