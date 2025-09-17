# Load required assemblies
Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase

# Define XAML for the WPF GUI
$xaml = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Key Word Event Viewer Parser" Width="1000" Height="700"
        WindowStyle="None" AllowsTransparency="True" Background="Transparent"
        ResizeMode="CanResizeWithGrip">
    <Border Background="#FF252526" CornerRadius="12" BorderBrush="#FF3F3F41" BorderThickness="1">
        <Grid>
            <Grid.RowDefinitions>
                <RowDefinition Height="35"/>
                <RowDefinition Height="*"/>
                <RowDefinition Height="25"/>
            </Grid.RowDefinitions>
            
            <!-- Title Bar -->
            <Grid Grid.Row="0" Background="#FF1B1B1C">
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="Auto"/>
                </Grid.ColumnDefinitions>
                
                <TextBlock Text="Key Word Parser - Application Errors &amp; Hangs" Foreground="#FFE4E4E4" FontSize="14" FontWeight="SemiBold" VerticalAlignment="Center" Margin="15,0,0,0"/>
                
                <StackPanel Grid.Column="1" Orientation="Horizontal">
                    <Button x:Name="RefreshButton" Content="↻" Width="40" Height="35" Background="Transparent" Foreground="#FFE4E4E4" BorderThickness="0" FontSize="16" ToolTip="Refresh Events"/>
                    <Button x:Name="MinimizeButton" Content="_" Width="40" Height="35" Background="Transparent" Foreground="#FFE4E4E4" BorderThickness="0" FontSize="16"/>
                    <Button x:Name="MaximizeButton" Content="□" Width="40" Height="35" Background="Transparent" Foreground="#FFE4E4E4" BorderThickness="0" FontSize="16"/>
                    <Button x:Name="CloseButton" Content="X" Width="40" Height="35" Background="Transparent" Foreground="#FFE4E4E4" BorderThickness="0" FontSize="16"/>
                </StackPanel>
            </Grid>
            
            <!-- Main Content -->
            <Grid Grid.Row="1" Margin="15">
                <Grid.RowDefinitions>
                    <RowDefinition Height="Auto"/>
                    <RowDefinition Height="Auto"/>
                    <RowDefinition Height="*"/>
                </Grid.RowDefinitions>
                
                <TextBlock Grid.Row="0" Text="Filtered Events (ID 1000 &amp; 1002) - Suspicious Paths &amp; Filenames for Cheats" Foreground="#FFE4E4E4" FontSize="18" FontWeight="Bold" Margin="0,0,0,10"/>
                
                <Grid Grid.Row="1" Margin="0,0,0,10">
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="Auto"/>
                        <ColumnDefinition Width="*"/>
                    </Grid.ColumnDefinitions>
                    <TextBlock Grid.Column="0" Text="Search:" Foreground="#FFE4E4E4" FontSize="14" VerticalAlignment="Center" Margin="0,0,10,0"/>
                    <TextBox x:Name="SearchBox" Grid.Column="1" Background="#FF1E1E1E" Foreground="#FFE4E4E4" BorderBrush="#FF3F3F41" BorderThickness="1" FontSize="12" Padding="5"/>
                </Grid>
                
                <ListView x:Name="EventsListView" Grid.Row="2" Background="#FF1E1E1E" Foreground="#FFE4E4E4" BorderBrush="#FF3F3F41" BorderThickness="1" ScrollViewer.HorizontalScrollBarVisibility="Auto" ScrollViewer.VerticalScrollBarVisibility="Auto">
                    <ListView.Resources>
                        <Style TargetType="ListViewItem">
                            <Setter Property="Background" Value="Transparent"/>
                            <Setter Property="BorderThickness" Value="0"/>
                            <Setter Property="Padding" Value="5"/>
                            <Setter Property="Margin" Value="0,2,0,2"/>
                            <Setter Property="ContextMenu">
                                <Setter.Value>
                                    <ContextMenu>
                                        <MenuItem Header="Copy App Name"/>
                                        <MenuItem Header="Copy App Path"/>
                                        <MenuItem Header="Copy Module Name"/>
                                        <MenuItem Header="Copy Module Path"/>
                                        <MenuItem Header="Copy Full Message"/>
                                    </ContextMenu>
                                </Setter.Value>
                            </Setter>
                            <Style.Triggers>
                                <Trigger Property="ItemsControl.AlternationIndex" Value="0">
                                    <Setter Property="Background" Value="#FF2A2A2B"/>
                                </Trigger>
                                <Trigger Property="ItemsControl.AlternationIndex" Value="1">
                                    <Setter Property="Background" Value="#FF252526"/>
                                </Trigger>
                            </Style.Triggers>
                        </Style>
                    </ListView.Resources>
                    <ListView.View>
                        <GridView>
                            <GridViewColumn Header="Time Created" Width="160">
                                <GridViewColumn.CellTemplate>
                                    <DataTemplate>
                                        <TextBlock Text="{Binding TimeCreated}" Foreground="#FFE4E4E4" FontSize="12"/>
                                    </DataTemplate>
                                </GridViewColumn.CellTemplate>
                            </GridViewColumn>
                            <GridViewColumn Header="Event ID" Width="80">
                                <GridViewColumn.CellTemplate>
                                    <DataTemplate>
                                        <TextBlock Text="{Binding Id}" Foreground="#FFE4E4E4" FontSize="12"/>
                                    </DataTemplate>
                                </GridViewColumn.CellTemplate>
                            </GridViewColumn>
                            <GridViewColumn Header="Application Name" Width="200">
                                <GridViewColumn.CellTemplate>
                                    <DataTemplate>
                                        <TextBlock Text="{Binding AppName}" Foreground="#FFE4E4E4" FontSize="12" TextWrapping="Wrap" ToolTip="{Binding AppName}"/>
                                    </DataTemplate>
                                </GridViewColumn.CellTemplate>
                            </GridViewColumn>
                            <GridViewColumn Header="Application Path" Width="300">
                                <GridViewColumn.CellTemplate>
                                    <DataTemplate>
                                        <TextBlock Text="{Binding AppPath}" Foreground="#FFE4E4E4" FontSize="12" TextWrapping="Wrap" ToolTip="{Binding AppPath}"/>
                                    </DataTemplate>
                                </GridViewColumn.CellTemplate>
                            </GridViewColumn>
                            <GridViewColumn Header="Module Name" Width="200">
                                <GridViewColumn.CellTemplate>
                                    <DataTemplate>
                                        <TextBlock Text="{Binding ModuleName}" Foreground="#FFE4E4E4" FontSize="12" TextWrapping="Wrap" ToolTip="{Binding ModuleName}"/>
                                    </DataTemplate>
                                </GridViewColumn.CellTemplate>
                            </GridViewColumn>
                            <GridViewColumn Header="Module Path" Width="300">
                                <GridViewColumn.CellTemplate>
                                    <DataTemplate>
                                        <TextBlock Text="{Binding ModulePath}" Foreground="#FFE4E4E4" FontSize="12" TextWrapping="Wrap" ToolTip="{Binding ModulePath}"/>
                                    </DataTemplate>
                                </GridViewColumn.CellTemplate>
                            </GridViewColumn>
                        </GridView>
                    </ListView.View>
                </ListView>
            </Grid>
            
            <!-- Status Bar -->
            <Grid Grid.Row="2" Background="#FF1B1B1C">
                <TextBlock x:Name="StatusText" Foreground="#FFE4E4E4" FontSize="12" VerticalAlignment="Center" Margin="15,0,0,0" Text="Ready"/>
            </Grid>
        </Grid>
    </Border>
</Window>
'@

# Parse XAML
$reader = New-Object System.Xml.XmlNodeReader ([xml]$xaml)
$window = [Windows.Markup.XamlReader]::Load($reader)

# Enable dragging the window
$window.Add_MouseLeftButtonDown({
    if ($_.Button -eq [System.Windows.Input.MouseButton]::Left) {
        $window.DragMove()
    }
})

# Button event handlers
$minimizeButton = $window.FindName("MinimizeButton")
$minimizeButton.Add_Click({
    $window.WindowState = [System.Windows.WindowState]::Minimized
})

$maximizeButton = $window.FindName("MaximizeButton")
$maximizeButton.Add_Click({
    if ($window.WindowState -eq [System.Windows.WindowState]::Normal) {
        $window.WindowState = [System.Windows.WindowState]::Maximized
        $maximizeButton.Content = "❐"
    } else {
        $window.WindowState = [System.Windows.WindowState]::Normal
        $maximizeButton.Content = "□"
    }
})

$closeButton = $window.FindName("CloseButton")
$closeButton.Add_Click({
    $window.Close()
})

$refreshButton = $window.FindName("RefreshButton")
$refreshButton.Add_Click({
    Load-Events
})

$eventsListView = $window.FindName("EventsListView")
$eventsListView.AlternationCount = 2

$searchBox = $window.FindName("SearchBox")

$statusText = $window.FindName("StatusText")

# Script-level variable for base events
$script:baseEvents = @()

# Function to parse event message into detailed object
function Parse-EventMessage {
    param ($message, $event)

    $details = @{}
    $lines = $message -split "`r`n"

    foreach ($line in $lines) {
        if ($line -match '^Faulting application name:\s*(.*),\s*version:\s*(.*),\s*time stamp:\s*(.*)') {
            $details['AppName'] = $matches[1].Trim()
            $details['AppVersion'] = $matches[2].Trim()
            $details['AppTimestampHex'] = $matches[3].Trim()
            try {
                $details['AppTimestamp'] = [datetime]::FromFileTime([Convert]::ToInt64($details['AppTimestampHex'], 16))
            } catch {
                $details['AppTimestamp'] = "Invalid timestamp"
            }
        } elseif ($line -match '^Faulting module name:\s*(.*),\s*version:\s*(.*),\s*time stamp:\s*(.*)') {
            $details['ModuleName'] = $matches[1].Trim()
            $details['ModuleVersion'] = $matches[2].Trim()
            $details['ModuleTimestampHex'] = $matches[3].Trim()
            try {
                $details['ModuleTimestamp'] = [datetime]::FromFileTime([Convert]::ToInt64($details['ModuleTimestampHex'], 16))
            } catch {
                $details['ModuleTimestamp'] = "Invalid timestamp"
            }
        } elseif ($line -match '^Exception code:\s*(.*)') {
            $details['ExceptionCode'] = $matches[1].Trim()
        } elseif ($line -match '^Fault offset:\s*(.*)') {
            $details['FaultOffset'] = $matches[1].Trim()
        } elseif ($line -match '^Faulting process id:\s*(.*)') {
            $details['ProcessId'] = $matches[1].Trim()
        } elseif ($line -match '^Faulting application start time:\s*(.*)') {
            $details['AppStartTimeHex'] = $matches[1].Trim()
            try {
                $details['AppStartTime'] = [datetime]::FromFileTime([Convert]::ToInt64($details['AppStartTimeHex'], 16))
            } catch {
                $details['AppStartTime'] = "Invalid timestamp"
            }
        } elseif ($line -match '^Faulting application path:\s*(.*)') {
            $details['AppPath'] = $matches[1].Trim()
        } elseif ($line -match '^Faulting module path:\s*(.*)') {
            $details['ModulePath'] = $matches[1].Trim()
        } elseif ($line -match '^Report Id:\s*(.*)') {
            $details['ReportId'] = $matches[1].Trim()
        } elseif ($line -match '^Faulting package full name:\s*(.*)') {
            $details['PackageFullName'] = $matches[1].Trim()
        } elseif ($line -match '^Faulting package-relative application ID:\s*(.*)') {
            $details['PackageAppId'] = $matches[1].Trim()
        } elseif ($line -match '^Hung application name:\s*(.*),\s*version:\s*(.*),\s*time stamp:\s*(.*)') {
            $details['AppName'] = $matches[1].Trim()
            $details['AppVersion'] = $matches[2].Trim()
            $details['AppTimestampHex'] = $matches[3].Trim()
            try {
                $details['AppTimestamp'] = [datetime]::FromFileTime([Convert]::ToInt64($details['AppTimestampHex'], 16))
            } catch {
                $details['AppTimestamp'] = "Invalid timestamp"
            }
        } elseif ($line -match '^Hung window title:\s*(.*)') {
            $details['WindowTitle'] = $matches[1].Trim()
        } elseif ($line -match '^Hung application path:\s*(.*)') {
            $details['AppPath'] = $matches[1].Trim()
        }
    }

    $details['TimeCreated'] = $event.TimeCreated
    $details['Id'] = $event.Id
    $details['FullMessage'] = $message

    # Add more cheat indicators
    $details['CheatIndicators'] = @()
    if ($details['ExceptionCode'] -eq '0xc0000005') {
        $details['CheatIndicators'] += "Access Violation (0xc0000005) - Often caused by cheat injections, memory manipulation, or DLL hooks in games."
    }
    if ($details['ModulePath'] -and ($details['ModulePath'].ToLower() -match '\\temp\\' -or $details['ModulePath'].ToLower() -match '\\appdata\\' -or $details['ModulePath'].ToLower() -match '\\downloads\\')) {
        $details['CheatIndicators'] += "Suspicious module location (Temp, AppData, or Downloads) - Cheats frequently use these folders to evade detection."
    }
    if ($details['ModuleName'] -and $details['ModuleName'] -match '[a-zA-Z0-9]{8,}\.dll') {
        $details['CheatIndicators'] += "Random alphanumeric DLL name - Common obfuscation technique for cheat loaders and injectors."
    }
    if ($details['AppName'] -match 'FiveM' -or $details['AppPath'] -match 'FiveM' -or $details['ModuleName'] -match 'FiveM' -or $details['ModulePath'] -match 'FiveM') {
        $details['CheatIndicators'] += "Directly related to FiveM process - Likely a crash caused by incompatible or malicious mods/cheats."
    }
    if ($details['ExceptionCode'] -eq '0xc0000409') {
        $details['CheatIndicators'] += "Security Check Failure (0xc0000409) - Could indicate anti-cheat detection or stack buffer overrun from exploits."
    }
    if ($details['FaultOffset'] -and [Convert]::ToInt64($details['FaultOffset'], 16) -gt 0) {
        $details['CheatIndicators'] += "Non-zero fault offset - May point to specific code in the module where the cheat interfered."
    }
    if (-not $details['ModulePath']) {
        $details['CheatIndicators'] += "Unknown module path - Some advanced cheats unload modules to hide their presence."
    }

    return $details
}

# Function to show detailed window
function Show-DetailWindow {
    param ($details)

    $detailXaml = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Event Details" Width="700" Height="600"
        Background="#FF252526" Foreground="#FFE4E4E4">
    <ScrollViewer>
        <StackPanel Margin="15">
            <TextBlock Text="Time Created:" FontWeight="Bold" FontSize="14"/>
            <TextBlock Text="{Binding TimeCreated}" Margin="0,0,0,15" FontSize="12"/>
            
            <TextBlock Text="Event ID:" FontWeight="Bold" FontSize="14"/>
            <TextBlock Text="{Binding Id}" Margin="0,0,0,15" FontSize="12"/>
            
            <TextBlock Text="Application Name:" FontWeight="Bold" FontSize="14"/>
            <TextBlock Text="{Binding AppName}" TextWrapping="Wrap" Margin="0,0,0,15" FontSize="12"/>
            
            <TextBlock Text="Application Path:" FontWeight="Bold" FontSize="14"/>
            <TextBlock Text="{Binding AppPath}" TextWrapping="Wrap" Margin="0,0,0,15" FontSize="12"/>
            
            <TextBlock Text="Application Version:" FontWeight="Bold" FontSize="14"/>
            <TextBlock Text="{Binding AppVersion}" Margin="0,0,0,15" FontSize="12"/>
            
            <TextBlock Text="Application Timestamp (Build Time):" FontWeight="Bold" FontSize="14"/>
            <TextBlock Text="{Binding AppTimestamp}" Margin="0,0,0,15" FontSize="12"/>
            
            <TextBlock Text="Application Start Time:" FontWeight="Bold" FontSize="14"/>
            <TextBlock Text="{Binding AppStartTime}" Margin="0,0,0,15" FontSize="12"/>
            
            <TextBlock Text="Module Name:" FontWeight="Bold" FontSize="14"/>
            <TextBlock Text="{Binding ModuleName}" TextWrapping="Wrap" Margin="0,0,0,15" FontSize="12"/>
            
            <TextBlock Text="Module Path:" FontWeight="Bold" FontSize="14"/>
            <TextBlock Text="{Binding ModulePath}" TextWrapping="Wrap" Margin="0,0,0,15" FontSize="12"/>
            
            <TextBlock Text="Module Version:" FontWeight="Bold" FontSize="14"/>
            <TextBlock Text="{Binding ModuleVersion}" Margin="0,0,0,15" FontSize="12"/>
            
            <TextBlock Text="Module Timestamp (Build Time):" FontWeight="Bold" FontSize="14"/>
            <TextBlock Text="{Binding ModuleTimestamp}" Margin="0,0,0,15" FontSize="12"/>
            
            <TextBlock Text="Exception Code:" FontWeight="Bold" FontSize="14"/>
            <TextBlock Text="{Binding ExceptionCode}" Margin="0,0,0,15" FontSize="12"/>
            
            <TextBlock Text="Fault Offset:" FontWeight="Bold" FontSize="14"/>
            <TextBlock Text="{Binding FaultOffset}" Margin="0,0,0,15" FontSize="12"/>
            
            <TextBlock Text="Process ID:" FontWeight="Bold" FontSize="14"/>
            <TextBlock Text="{Binding ProcessId}" Margin="0,0,0,15" FontSize="12"/>
            
            <TextBlock Text="Report ID:" FontWeight="Bold" FontSize="14"/>
            <TextBlock Text="{Binding ReportId}" Margin="0,0,0,15" FontSize="12"/>
            
            <TextBlock Text="Window Title (for Hangs):" FontWeight="Bold" FontSize="14"/>
            <TextBlock Text="{Binding WindowTitle}" Margin="0,0,0,15" FontSize="12"/>
            
            <TextBlock Text="Package Full Name:" FontWeight="Bold" FontSize="14"/>
            <TextBlock Text="{Binding PackageFullName}" Margin="0,0,0,15" FontSize="12"/>
            
            <TextBlock Text="Package App ID:" FontWeight="Bold" FontSize="14"/>
            <TextBlock Text="{Binding PackageAppId}" Margin="0,0,0,15" FontSize="12"/>
            
            <TextBlock Text="Potential Cheat Indicators:" FontWeight="Bold" FontSize="14" Margin="0,10,0,0"/>
            <ItemsControl ItemsSource="{Binding CheatIndicators}">
                <ItemsControl.ItemTemplate>
                    <DataTemplate>
                        <TextBlock Text="{Binding}" Margin="0,0,0,5" Foreground="#FFFFA07A" TextWrapping="Wrap" FontSize="12"/>
                    </DataTemplate>
                </ItemsControl.ItemTemplate>
            </ItemsControl>
            
            <TextBlock Text="Full Event Message:" FontWeight="Bold" FontSize="14" Margin="0,15,0,0"/>
            <TextBox Text="{Binding FullMessage}" IsReadOnly="True" TextWrapping="Wrap" Height="250" Background="#FF1E1E1E" Foreground="#FFE4E4E4" BorderThickness="1" BorderBrush="#FF3F3F41" FontSize="12" Padding="5"/>
        </StackPanel>
    </ScrollViewer>
</Window>
'@

    $detailReader = New-Object System.Xml.XmlNodeReader ([xml]$detailXaml)
    $detailWindow = [Windows.Markup.XamlReader]::Load($detailReader)
    $detailWindow.DataContext = New-Object -TypeName PSObject -Property $details
    $detailWindow.ShowDialog() | Out-Null
}

# Function to load and filter events
function Load-Events {
    $statusText.Text = "Loading events..."
    $eventsListView.ItemsSource = $null
    $tempEvents = @()

    # Expanded keywords for cheats
    $keywords = @('launcher', 'settings.cock', 'external', 'cheat', 'mod', 'menu', 'loader', 'fivem', 'citizenfx', 'redengine', 'eulen', 'luna', 'hx', '9z', 'tz', 'crown', 'skript', 'nexus', 'phaze', 'inject', 'executor', 'aimbot', 'esp', 'godmode', 'teleport', 'dll')
    # Regex for random alphanumeric file names
    $randomRegex = '[a-zA-Z0-9]{8,}(\.exe|\.dll)?'

    # Get events
    $events = Get-WinEvent -FilterHashtable @{LogName='Application'; ID=1000,1002} -MaxEvents 50000 -ErrorAction SilentlyContinue

    foreach ($event in $events) {
        $message = $event.Message

        # Parse details
        $details = Parse-EventMessage -message $message -event $event

        # Check only Application Name and Application Path for filtering
        $fields = @($details['AppName'], $details['AppPath']) | Where-Object { $_ }
        $matches = $false

        foreach ($field in $fields) {
            $fieldLower = $field.ToLower()
            foreach ($kw in $keywords) {
                if ($fieldLower -like "*$kw*") {
                    $matches = $true
                    break
                }
            }
            if ($matches) { break }
            if ($fieldLower -match $randomRegex) {
                $matches = $true
                break
            }
        }

        if ($matches) {
            $item = [PSCustomObject]@{
                TimeCreated = $details['TimeCreated']
                Id = $details['Id']
                AppName = $details['AppName']
                AppPath = $details['AppPath']
                ModuleName = $details['ModuleName']
                ModulePath = $details['ModulePath']
                Details = $details
            }
            $tempEvents += $item
        }
    }

    # Remove duplicates based on identical AppName, AppPath, ModuleName, ModulePath
    $script:baseEvents = $tempEvents | Group-Object -Property AppName, AppPath, ModuleName, ModulePath | ForEach-Object { $_.Group | Select-Object -First 1 }

    # Bind to ListView
    $eventsListView.ItemsSource = $script:baseEvents
    $statusText.Text = "Loaded $($script:baseEvents.Count) unique filtered events."
}

# Search functionality (live as you type)
$searchBox.Add_TextChanged({
    $searchText = $searchBox.Text.ToLower()
    if ([string]::IsNullOrEmpty($searchText)) {
        $eventsListView.ItemsSource = $script:baseEvents
    } else {
        $filtered = $script:baseEvents | Where-Object {
            ($_.AppName -and $_.AppName.ToLower() -like "*$searchText*") -or
            ($_.AppPath -and $_.AppPath.ToLower() -like "*$searchText*") -or
            ($_.ModuleName -and $_.ModuleName.ToLower() -like "*$searchText*") -or
            ($_.ModulePath -and $_.ModulePath.ToLower() -like "*$searchText*") -or
            ($_.Details.FullMessage.ToLower() -like "*$searchText*")
        }
        $eventsListView.ItemsSource = @($filtered)
    }
})

# Double-click to view details
$eventsListView.Add_MouseDoubleClick({
    if ($eventsListView.SelectedItem) {
        $selected = $eventsListView.SelectedItem
        Show-DetailWindow -details $selected.Details
    }
})

# Context menu (right-click)
$eventsListView.Add_ContextMenuOpening({
    $item = $eventsListView.SelectedItem
    if ($item) {
        $contextMenu = $_.Source.ContextMenu
        $menuItems = $contextMenu.Items
        $menuItems[0].Add_Click({
            if ($item.AppName) { Set-Clipboard -Text $item.AppName }
        })
        $menuItems[1].Add_Click({
            if ($item.AppPath) { Set-Clipboard -Text $item.AppPath }
        })
        $menuItems[2].Add_Click({
            if ($item.ModuleName) { Set-Clipboard -Text $item.ModuleName }
        })
        $menuItems[3].Add_Click({
            if ($item.ModulePath) { Set-Clipboard -Text $item.ModulePath }
        })
        $menuItems[4].Add_Click({
            if ($item.Details.FullMessage) { Set-Clipboard -Text $item.Details.FullMessage }
        })
    }
})

# Initial load
Load-Events

# Show the window
$window.ShowDialog() | Out-Null
