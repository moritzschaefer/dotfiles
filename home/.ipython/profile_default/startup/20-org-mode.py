import IPython
from tabulate import tabulate
import numpy as np
import pandas as pd


class OrgFormatter(IPython.core.formatters.BaseFormatter):
    def __call__(self, obj):
        if type(obj) in (pd.DataFrame, np.ndarray, np.matrix, pd.Series):
            if not getattr(
                obj, "show_all", None
            ):  # show_all attribute prevents truncation
                try:
                    obj = obj.iloc[:10]
                except AttributeError:
                    obj = obj[:10]

            try:
                return tabulate(
                    obj, headers="keys", tablefmt="orgtbl", showindex="always"
                )
            except:
                pass

        return None


ip = IPython.get_ipython()
ip.display_formatter.formatters["text/org"] = OrgFormatter()
