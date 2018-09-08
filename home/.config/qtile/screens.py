from libqtile.config import Screen
from bars import main_bar


screens = [
    Screen(
        bottom=main_bar),
    Screen()
]


# def main(qtile):
#     num_screens = len(qtile.conn.pseudoscreens)
#
#     if num_screens > 1:
#         screens.append(Screen())
