#!/bin/bash
clear

# --- Setup and Inputs ---

# Get current username and define path
USER_NAME=$(whoami)
TARGET_DIR="/home/$USER_NAME/WebApps/Scripts"

# Create the directory if it doesn't exist
mkdir -p "$TARGET_DIR"

# Ask for the App Name
read -p "Enter the application name (e.g., Netflix): " app_name
app_name=${app_name:-"WebApp"} # Default if empty

# Ask for the URL with validation
while true; do
    read -p "Enter the website URL (include http:// or https://): " site_url
    if [[ $site_url =~ ^https?://[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}.* ]]; then
        break
    else
        echo "❌ Invalid URL format. Please make sure it starts with http:// or https://"
    fi
done

# Ask for Scaling
echo "-------------------------------------------------------"
echo "Select Scaling Factor (Standard is 1.0)"
echo "Recommendation: Use '2' for 4K TVs or '1.25' for 1080p"
echo "-------------------------------------------------------"
read -p "Enter scale factor [Default 2]: " scale_factor
scale_factor=${scale_factor:-2}

# Navigate to the target folder
cd "$TARGET_DIR" || exit

# --- Script Generation ---
cat <<EOF > "$app_name.sh"
#!/bin/bash
/usr/bin/flatpak run --branch=stable --arch=x86_64 com.microsoft.Edge --new-window --force-device-scale-factor=$scale_factor --kiosk "$site_url"
EOF

chmod +x ./"$app_name.sh"

echo "✅ $app_name.sh successfully created in $TARGET_DIR!"

# --- Steam Integration ---

if command -v steamos-add-to-steam &> /dev/null; then
    steamos-add-to-steam "$TARGET_DIR/$app_name.sh"
    echo "🎮 Added to Steam library!"
else
    echo "⚠️ 'steamos-add-to-steam' not found. Please add the script to Steam manually."
fi
