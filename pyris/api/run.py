# -*- coding: utf-8 -*-
import sys
import settings
from pyris.api import create_app

app = create_app()

if __name__ == "__main__":
    reload(sys)
    sys.setdefaultencoding('utf-8')
    app.run(port=5555, debug=True)
