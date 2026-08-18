#!/volume1/homes/k0ng/el_tracker/elvenv/bin/python3

from pathlib import Path

def create_structure(base_path, structure):
    """
    Recursively creates directories from a nested dictionary structure.
    """
    for name, content in structure.items():
        # Combine current base path with the key name
        current_path = Path(base_path) / name
        
        if isinstance(content, dict):
            # If the value is a dictionary, create a folder and recurse into it
            current_path.mkdir(parents=True, exist_ok=True)
            create_structure(current_path, content)
            
        elif isinstance(content, list):
            # If the value is a list, treat items as empty subdirectories
            for sub_dir in content:
                (current_path / sub_dir).mkdir(parents=True, exist_ok=True)
                
        elif content is None:
            # If value is None, just create the single leaf directory
            current_path.mkdir(parents=True, exist_ok=True)

# 1. Define your blueprint dictionary (aka: json format)
projects_blueprint = {
    "airsonic": {
        "media": {
            "artworks": None,
            "covers": None
        },
        "playlists": None,
        "podcasts": None
    },
    "keepassxc": {
        "Desktop": {
            "components": None,
            "utils": None
        },
        "ssl": None
    },
    "mariadb": {
        "backup": None,
        "config": None,
        "data": None,
        "scripts": None,
        "secrets": None,
        "ssl": None
    },
    "nginx": {
        "conf.d": None,
        "ssl": None
    },
    "vault": {
        "config": None,
        "data": None,
        "plugins": None,
        "ssl": None
    }
}

# 2. Define where you want to build this layout (e.g., current directory '.')
target_directory = "/volume1/AppData"

# 3. Execute the function
create_structure(target_directory, projects_blueprint)
print("Directory structure successfully created!")
