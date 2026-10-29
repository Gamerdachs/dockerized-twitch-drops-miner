import os
import runpy
import sys
from pathlib import Path

import constants


config_dir = Path(os.environ.get("TDM_CONFIG_DIR", "/TwitchDropsMiner/config"))
config_dir.mkdir(parents=True, exist_ok=True)

# Keep TDM data files together in the mounted config volume.
constants.SETTINGS_PATH = config_dir / "settings.json"
constants.COOKIES_PATH = config_dir / "cookies.jar"
constants.LOG_PATH = config_dir / "log.txt"
constants.DUMP_PATH = config_dir / "dump.dat"
constants.LOCK_PATH = config_dir / "lock.file"
constants.CACHE_PATH = config_dir / "cache"
constants.CACHE_DB = constants.CACHE_PATH / "mapping.json"

main_path = Path(__file__).with_name("main.py")
sys.argv[0] = str(main_path)
runpy.run_path(str(main_path), run_name="__main__")