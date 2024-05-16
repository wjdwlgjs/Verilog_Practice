import serial
import threading
import sys
from PyQt5.QtWidgets import QApplication, QWidget, QVBoxLayout, QCheckBox, QComboBox, QLineEdit, QPushButton, QLabel
import time

serial_interface = serial.Serial("COM5", 9600, 8, "N", 1, 2)
send_data = None

write_thread_activate = True
read_thread_activate = True

read_now = False
write_now = False

def write_data(interface: serial.Serial):
    global send_data, write_thread_activate, write_now
    while write_thread_activate:
        if write_now:
            time.sleep(0.5)
            interface.write(send_data)
            print("Sent Data:", send_data)
            write_now = False

def read_data(interface: serial.Serial):
    global read_thread_activate, read_now
    while read_thread_activate:
        if read_now:
            response = interface.read(21)
            print("Recieved Data:", response)
            read_now = False
        

write_thread = threading.Thread(target = write_data, args = (serial_interface,))
read_thread = threading.Thread(target = read_data, args = (serial_interface, ))

def float_to_fixedpoint(target_float):
    target_float_abs = abs(target_float)
    target_float_shifted = int(target_float_abs * (2**15))
    if target_float < 0:
        target_float_shifted = (0xffffffff ^ target_float_shifted) + 1
    
    most_significant_byte = ((0xff000000 & target_float_shifted) >> 24).to_bytes()
    second_msbyte = ((0x00ff0000 & target_float_shifted) >> 16).to_bytes()
    second_lsbyte = ((0x0000ff00 & target_float_shifted) >> 8).to_bytes()
    least_significant_byte = (0x000000ff & target_float_shifted).to_bytes()

    assert len(most_significant_byte) == len(second_msbyte) == len(second_lsbyte) == len(least_significant_byte) == 1

    return least_significant_byte + second_lsbyte + second_msbyte + most_significant_byte

def int_to_int(target_int):
    target_int = max(0, target_int) 

    most_significant_byte = ((0xff000000 & target_int) >> 24).to_bytes()
    second_msbyte = ((0x00ff0000 & target_int) >> 16).to_bytes()
    second_lsbyte = ((0x0000ff00 & target_int) >> 8).to_bytes()
    least_significant_byte = (0x000000ff & target_int).to_bytes()

    assert len(most_significant_byte) == len(second_msbyte) == len(second_lsbyte) == len(least_significant_byte) == 1

    return least_significant_byte + second_lsbyte + second_msbyte + most_significant_byte

def encode_settings(is_digital: bool, mode, debug: bool = True):
    result_int = 0
    if (is_digital):
        result_int += 1
    
    assert 0 <= mode <= 3
    result_int += 2 * mode

    if (debug):
        result_int += 8
    
    return (0x000000ff & result_int).to_bytes()

def encode_all(settings: bytes, desired_value: bytes, k_p: bytes, k_i: bytes, k_d: bytes):
    return settings + desired_value + k_p + k_i + k_d

class SettingsWindow(QWidget):
    def __init__(self):
        super().__init__()

        self.is_digital = False
        self.debug = False
        self.mode = 0

        self.init_ui()

    def init_ui(self):
        layout = QVBoxLayout()

        # True/False Checkbox
        self.checkbox1 = QCheckBox("is_digital")
        layout.addWidget(self.checkbox1)

        # Selector of 0~4
        self.combobox = QComboBox()
        self.combobox.addItems(["0", "1", "2", "3"])
        layout.addWidget(self.combobox)

        # Another True/False Checkbox
        self.checkbox2 = QCheckBox("debug")
        layout.addWidget(self.checkbox2)

        # Four Input Panels
        self.input_panels = []
        for i in range(4):
            label = QLabel(f"Input {i+1}: ")
            input_panel = QLineEdit()
            self.input_panels.append(input_panel)
            layout.addWidget(label)
            layout.addWidget(input_panel)

        # Update Settings Button
        self.update_button = QPushButton("Update Settings")
        self.update_button.clicked.connect(self.update_settings)
        layout.addWidget(self.update_button)

        self.setLayout(layout)
        self.setWindowTitle("Settings")

    def update_settings(self):
        # Example function for updating settings
        self.is_digital = self.checkbox1.isChecked()
        self.mode = int(self.combobox.currentText())
        self.debug = self.checkbox2.isChecked()
        input_values = [panel.text() for panel in self.input_panels]

        self.desired_value = float(input_values[0])
        self.manual_throttle = int(self.desired_value)
        self.k_p = float(input_values[1])
        self.k_i = float(input_values[2])
        self.k_d = float(input_values[3])

        global send_data, read_now, write_now
        if (self.mode != 2):
            send_data = encode_all(
                encode_settings(self.is_digital, self.mode, self.debug),
                int_to_int(self.manual_throttle),
                float_to_fixedpoint(self.k_p),
                float_to_fixedpoint(self.k_i),
                float_to_fixedpoint(self.k_d)
            )
        else:
            send_data = encode_all(
                encode_settings(self.is_digital, self.mode, self.debug),
                float_to_fixedpoint(self.desired_value),
                float_to_fixedpoint(self.k_p),
                float_to_fixedpoint(self.k_i),
                float_to_fixedpoint(self.k_d)
            )
        read_now = self.debug
        write_now = True
        
        


if __name__ == '__main__':
    app = QApplication(sys.argv)
    read_thread.start()
    write_thread.start()
    window = SettingsWindow()
    window.show()
    # read_thread.join()
    # write_thread.join()
    sys.exit(app.exec_())
    

""" for i in range(18):
    print("assign leds_o[%d] = written_values[%d:%d] != 8'b0;"%(i, 8*i-1, 8*i-8)) """