#!/usr/bin/env python3
"""
ENEA Vault - Local AI Profile Builder
Runs in Termux on Android
"""

import os
import json
import shutil
from datetime import datetime
from flask import Flask, render_template, request, jsonify, send_file
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

# Configuration
VAULT_PATH = "/storage/emulated/0/ENEA_Vault"
INPUT_PATH = os.path.join(VAULT_PATH, "input")
SORTED_PATH = os.path.join(VAULT_PATH, "sorted")
OUTPUT_PATH = os.path.join(VAULT_PATH, "output")

# Ensure directories exist
for path in [VAULT_PATH, INPUT_PATH, SORTED_PATH, OUTPUT_PATH]:
    os.makedirs(path, exist_ok=True)

@app.route('/')
def index():
    """Serve the main web interface"""
    return '''
    <!DOCTYPE html>
    <html>
    <head>
        <title>ENEA Vault</title>
        <style>
            body { font-family: -apple-system, sans-serif; background: #0f172a; color: white; padding: 20px; }
            .container { max-width: 600px; margin: 0 auto; }
            .card { background: #1e293b; padding: 30px; border-radius: 15px; margin: 20px 0; }
            .btn { background: #6366f1; color: white; border: none; padding: 15px 30px; border-radius: 10px; font-size: 16px; cursor: pointer; margin: 10px 0; width: 100%; }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>🎉 ENEA Vault is Running!</h1>
            
            <div class="card">
                <h2>📁 Step 1: Put Your Photos</h2>
                <p>Place photos in: <code>/storage/emulated/0/ENEA_Vault/input/</code></p>
                <button class="btn" onclick="scanPhotos()">📁 Scan Photos</button>
            </div>
            
            <div class="card">
                <h2>🤖 Step 2: Sort Photos</h2>
                <p>AI will organize your photos into categories</p>
                <button class="btn" onclick="sortPhotos()">🤖 Start AI Sorting</button>
            </div>
            
            <div class="card">
                <h2>✨ Step 3: Build Profile</h2>
                <p>Create your personal profile with text and images</p>
                <button class="btn" onclick="buildProfile()">✨ Build Profile</button>
            </div>
            
            <div class="card">
                <h2>📤 Step 4: Get Results</h2>
                <p>Download your HTML profile</p>
                <button class="btn" onclick="downloadProfile()">📥 Download Profile</button>
            </div>
        </div>
        
        <script>
            function scanPhotos() { alert('Scanning photos... (This will work when AI is added)'); }
            function sortPhotos() { alert('Sorting with AI... (This will work when AI is added)'); }
            function buildProfile() { alert('Building profile... (This will work when AI is added)'); }
            function downloadProfile() { alert('Downloading... (This will work when AI is added)'); }
        </script>
    </body>
    </html>
    '''

@app.route('/api/scan', methods=['POST'])
def scan_photos():
    """Scan input folder"""
    try:
        files = []
        for f in os.listdir(INPUT_PATH)[:20]:
            files.append(f)
        return jsonify({'success': True, 'count': len(files), 'files': files})
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)})

if __name__ == '__main__':
    print("=" * 60)
    print("🚀 ENEA Vault Server Starting...")
    print(f"📁 Vault Path: {VAULT_PATH}")
    print("🌐 Open: http://localhost:5000")
    print("=" * 60)
    app.run(host='0.0.0.0', port=5000, debug=False)