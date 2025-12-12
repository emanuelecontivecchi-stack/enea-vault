#!/bin/bash
# ================================================
# ENEA Vault - Termux Auto-Setup Script
# ================================================

echo "=================================================="
echo "🚀 ENEA Vault Setup for Termux"
echo "=================================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print status
print_status() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

# Step 1: Update packages
print_status "Updating Termux packages..."
pkg update -y && pkg upgrade -y

# Step 2: Install Python and dependencies
print_status "Installing Python and dependencies..."
pkg install python -y
pkg install libjpeg-turbo libpng wget curl -y

# Step 3: Request storage permission
print_status "Requesting storage permission..."
termux-setup-storage
sleep 2

# Step 4: Create vault directory structure
print_status "Creating vault directories..."
VAULT_PATH="/storage/emulated/0/ENEA_Vault"
mkdir -p "$VAULT_PATH/input"
mkdir -p "$VAULT_PATH/sorted/1_Documents"
mkdir -p "$VAULT_PATH/sorted/2_SFW_Media"
mkdir -p "$VAULT_PATH/sorted/3_NSFW_Private"
mkdir -p "$VAULT_PATH/sorted/4_Needs_Review"
mkdir -p "$VAULT_PATH/output"
mkdir -p "$VAULT_PATH/models"

echo "Vault structure created at: $VAULT_PATH"

# Step 5: Install Python packages
print_status "Installing Python packages..."
pip install --upgrade pip

# Install packages one by one to handle errors
packages=("flask" "pillow" "torch" "torchvision" "transformers" "nsfw-detector" "numpy" "opencv-python-headless" "requests")

for package in "${packages[@]}"; do
    print_status "Installing $package..."
    pip install "$package" --quiet
done

# Step 6: Download the application files
print_status "Downloading ENEA Vault application..."
cd "$VAULT_PATH"

# Download app.py
if wget -q -O app.py "https://raw.githubusercontent.com/emanuelecontivecchi-stack/enea-vault/main/app.py"; then
    print_status "Downloaded app.py"
else
    print_error "Failed to download app.py"
    exit 1
fi

# Download requirements.txt
if wget -q -O requirements.txt "https://raw.githubusercontent.com/emanuelecontivecchi-stack/enea-vault/main/requirements.txt"; then
    print_status "Downloaded requirements.txt"
else
    print_warning "Could not download requirements.txt, using default packages"
fi

# Step 7: Create a start script
print_status "Creating start script..."
cat > start_enea.sh << 'EOF'
#!/bin/bash
echo "=================================================="
echo "🚀 Starting ENEA Vault"
echo "=================================================="
cd /storage/emulated/0/ENEA_Vault
echo "Starting Python server on port 5000..."
echo "Open your browser and go to: http://localhost:5000"
echo ""
echo "Press Ctrl+C to stop the server"
echo "=================================================="
python app.py
EOF

chmod +x start_enea.sh

# Step 8: Create a desktop shortcut for Termux
print_status "Creating Termux shortcut..."
SHORTCUT_DIR="/data/data/com.termux/files/home/.shortcuts"
mkdir -p "$SHORTCUT_DIR"

cat > "$SHORTCUT_DIR/ENEA Vault" << EOF
#!/bin/bash
cd /storage/emulated/0/ENEA_Vault
python app.py
EOF

chmod +x "$SHORTCUT_DIR/ENEA Vault"

echo ""
echo "=================================================="
echo "✅ SETUP COMPLETED SUCCESSFULLY!"
echo "=================================================="
echo ""
echo "📁 Your vault is located at:"
echo "   $VAULT_PATH"
echo ""
echo "📸 To add photos:"
echo "   1. Copy photos to: $VAULT_PATH/input/"
echo "   2. Or use any file manager to copy files there"
echo ""
echo "🚀 To start ENEA Vault:"
echo "   Method 1: Run in Termux:"
echo "     cd /storage/emulated/0/ENEA_Vault"
echo "     python app.py"
echo ""
echo "   Method 2: Use the Termux shortcut:"
echo "     - Open Termux"
echo "     - Type: shortcuts"
echo "     - Select 'ENEA Vault'"
echo ""
echo "🌐 Then open in your browser:"
echo "   http://localhost:5000"
echo ""
echo "=================================================="
echo "Need help? Visit: https://github.com/emanuelecontivecchi-stack/enea-vault"
echo "=================================================="

# Try to open the browser automatically
if command -v termux-open-url &> /dev/null; then
    echo "Opening browser in 5 seconds..."
    sleep 5
    termux-open-url "http://localhost:5000"
fi