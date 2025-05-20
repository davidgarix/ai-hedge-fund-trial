#!/bin/zsh

# Function to handle errors and exit if any command fails
handle_error() {
  echo "❌ Error: $1"
  exit 1
}

# Step 1: Install direnv using Homebrew
echo "🔧 Installing direnv..."
if ! brew install direnv; then
  handle_error "Failed to install direnv. Please check your Homebrew installation."
fi
echo "✅ direnv installed successfully."

# Step 2: Add direnv hook to Zsh configuration
echo "🔧 Adding direnv hook to Zsh..."
if ! eval "$(direnv hook zsh)"; then
  handle_error "Failed to add direnv hook to Zsh."
fi
echo "✅ direnv hook added to Zsh."

# Step 3: Reload Zsh configuration
echo "🔧 Reloading Zsh configuration..."
if ! source ~/.zshrc; then
  handle_error "Failed to reload Zsh configuration."
fi
echo "✅ Zsh configuration reloaded."

# Step 4: Check and install Python 3.12
echo "🔍 Checking for Python 3.12..."
if ! command -v python3.12 &> /dev/null; then
    echo "🔧 Installing Python 3.12..."
    if ! brew install python@3.12; then
        handle_error "Failed to install Python 3.12"
    fi
    echo "✅ Python 3.12 installed successfully."
else
    echo "✅ Python 3.12 is already installed."
fi

# Step 5: Get the current working directory
CURRENT_DIR=$(pwd)
echo "📂 Current directory is: $CURRENT_DIR"

# Step 6: Create a Python virtual environment in the current directory
echo "🔧 Creating a virtual environment in $CURRENT_DIR..."
if ! python3.12 -m venv venv; then
  handle_error "Failed to create virtual environment with Python 3.12"
fi
echo "✅ Virtual environment created with Python 3.12."

# Step 6.1: Upgrade pip to latest version
echo "🔧 Upgrading pip to latest version..."
if ! ./venv/bin/pip install --upgrade pip; then
  handle_error "Failed to upgrade pip"
fi
echo "✅ pip upgraded to latest version."

# Step 6.2: Install terminal enhancement packages within the virtual environment
echo "🔧 Installing terminal enhancement packages in the virtual environment..."
if ! ./venv/bin/pip install rich tqdm colorama halo click pyfiglet; then
  handle_error "Failed to install terminal enhancement packages"
fi
echo "✅ Terminal enhancement packages installed in the virtual environment."

# Step 7: Write the virtual environment activation command to .envrc
echo "🔧 Setting up .envrc file..."
if ! echo "source $CURRENT_DIR/venv/bin/activate" > .envrc; then
  handle_error "Failed to write to .envrc."
fi
echo "✅ .envrc file set up."

# Step 8: Allow direnv to use the .envrc file
echo "🔧 Allowing direnv to load the .envrc file..."
if ! direnv allow; then
  handle_error "Failed to allow direnv to load the .envrc file."
fi
echo "✅ direnv allowed to load the .envrc file."

# Step 9: Create a simple demo script to show terminal enhancements
echo "🔧 Creating a demo script for terminal enhancements..."
cat > terminal_demo.py << 'EOF'
#!/usr/bin/env python3
"""
Demo script to showcase terminal enhancements.
Run this with: python terminal_demo.py
"""
import time
from rich.console import Console
from rich.progress import Progress, TextColumn, BarColumn, TimeElapsedColumn
from rich.panel import Panel
from rich.table import Table
from rich import print as rprint
from halo import Halo
import pyfiglet

# Create a console instance
console = Console()

# Print a fancy title
title = pyfiglet.figlet_format("Terminal UI Demo", font="slant")
console.print(f"[bold cyan]{title}[/bold cyan]")

# Show a panel with information
console.print(Panel.fit(
    "[bold green]Terminal UI Enhancement Demo[/bold green]\n"
    "This script demonstrates the rich terminal UI capabilities installed in your virtual environment",
    title="Welcome"
))

# Show a spinner
spinner = Halo(text='Loading', spinner='dots')
spinner.start()
time.sleep(2)
spinner.succeed('Loaded successfully')

# Create a table
table = Table(title="Installed Packages")
table.add_column("Package", style="cyan")
table.add_column("Purpose", style="green")

table.add_row("rich", "Rich text and formatting in the terminal")
table.add_row("tqdm", "Fast, extensible progress bars")
table.add_row("colorama", "Cross-platform colored terminal text")
table.add_row("halo", "Beautiful terminal spinners")
table.add_row("click", "Command-line interface creation kit")
table.add_row("pyfiglet", "ASCII art text")

console.print(table)

# Show a progress bar
total_steps = 10
console.print("\n[yellow]Demonstrating progress bar:[/yellow]")
with Progress(
    TextColumn("[bold blue]{task.description}"),
    BarColumn(),
    TextColumn("[bold green]{task.percentage:.0f}%"),
    TimeElapsedColumn(),
) as progress:
    task = progress.add_task("[cyan]Processing...", total=total_steps)
    
    for i in range(total_steps):
        time.sleep(0.5)  # Simulate work being done
        progress.update(task, advance=1)

# Show some styled text
console.print("\n[bold green]✓[/bold green] All terminal enhancements are working properly!")
console.print("[bold yellow]You can now enjoy a rich terminal experience in your project.[/bold yellow]")
console.print("[italic]Check the documentation of each package for more features.[/italic]")
EOF

chmod +x terminal_demo.py

# Step 10: Final success message and prompt to close the terminal
echo "🎉 Virtual environment created and direnv configured successfully!"
echo "📚 Installed terminal enhancement packages (in virtual environment only):"
echo "   - rich: Rich text and formatting in the terminal"
echo "   - tqdm: Fast, extensible progress bars"
echo "   - colorama: Cross-platform colored terminal text"
echo "   - halo: Beautiful terminal spinners"
echo "   - click: Command-line interface creation kit"
echo "   - pyfiglet: ASCII art text"
echo ""
echo "🚀 You can now close the terminal or continue working in the virtual environment."
echo "💡 Run the demo script to see examples: python terminal_demo.py"

