# Load required assemblies
Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase, System.Drawing

# Define XAML for the modern WPF GUI
$xaml = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Suspicious Event Parser" Width="1200" Height="800"
        WindowStyle="None" AllowsTransparency="True" Background="Transparent"
        ResizeMode="CanResizeWithGrip" FontFamily="Segoe UI">
        
    <Window.Resources>
        <DropShadowEffect x:Key="ShadowEffect" ShadowDepth="2" Direction="320" Color="Black" Opacity="0.3" BlurRadius="10"/>
        <Style x:Key="RoundedButtonStyle" TargetType="Button">
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border x:Name="Border" Background="{TemplateBinding Background}" CornerRadius="3" Padding="{TemplateBinding Padding}" BorderThickness="{TemplateBinding BorderThickness}" BorderBrush="{TemplateBinding BorderBrush}">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter TargetName="Border" Property="Background" Value="#FF404040"/>
                            </Trigger>
                            <Trigger Property="IsPressed" Value="True">
                                <Setter TargetName="Border" Property="Background" Value="#FF303030"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
        <Style x:Key="RoundedTextBoxStyle" TargetType="TextBox">
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="TextBox">
                        <Border Background="{TemplateBinding Background}" BorderBrush="{TemplateBinding BorderBrush}" BorderThickness="{TemplateBinding BorderThickness}" CornerRadius="3">
                            <ScrollViewer x:Name="PART_ContentHost" Margin="{TemplateBinding Padding}"/>
                        </Border>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
    </Window.Resources>
        
    <Border Background="#FF1E1E1E" CornerRadius="10" BorderBrush="#FF404040" BorderThickness="1"
            Effect="{StaticResource ShadowEffect}">
        <Grid>
            <Grid.RowDefinitions>
                <RowDefinition Height="45"/>
                <RowDefinition Height="Auto"/>
                <RowDefinition Height="*"/>
                <RowDefinition Height="35"/>
            </Grid.RowDefinitions>
            
            <!-- Modern Title Bar -->
            <Border Grid.Row="0" Background="#FF2D2D30" CornerRadius="10,10,0,0">
                <Grid>
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="Auto"/>
                        <ColumnDefinition Width="*"/>
                        <ColumnDefinition Width="Auto"/>
                    </Grid.ColumnDefinitions>
                    
                    <!-- App Icon and Title -->
                    <StackPanel Grid.Column="0" Orientation="Horizontal" VerticalAlignment="Center" Margin="15,0,0,0">
                        <TextBlock Text="🔍" FontSize="16" VerticalAlignment="Center" Margin="0,0,8,0"/>
                        <TextBlock Text="Suspicious Event Parser" Foreground="#FFFFFFFF" FontSize="14" FontWeight="SemiBold" VerticalAlignment="Center"/>
                    </StackPanel>
                    
                    <!-- Window Controls -->
                    <StackPanel Grid.Column="2" Orientation="Horizontal">
                        <Button x:Name="MinimizeButton" Content="─" Width="35" Height="30" Background="Transparent" 
                                Foreground="#FFCCCCCC" BorderThickness="0" FontSize="12" FontWeight="Bold"
                                ToolTip="Minimize"/>
                        <Button x:Name="MaximizeButton" Content="□" Width="35" Height="30" Background="Transparent" 
                                Foreground="#FFCCCCCC" BorderThickness="0" FontSize="12"
                                ToolTip="Maximize"/>
                        <Button x:Name="CloseButton" Content="✕" Width="35" Height="30" Background="Transparent" 
                                Foreground="#FFCCCCCC" BorderThickness="0" FontSize="12" FontWeight="SemiBold"
                                ToolTip="Close"/>
                    </StackPanel>
                </Grid>
            </Border>
            
            <!-- Toolbar Section -->
            <Border Grid.Row="1" Background="#FF252526" Margin="10,5,10,5" CornerRadius="5" BorderBrush="#FF3E3E40" BorderThickness="1">
                <Grid Margin="10">
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="Auto"/>
                        <ColumnDefinition Width="*"/>
                        <ColumnDefinition Width="Auto"/>
                        <ColumnDefinition Width="Auto"/>
                    </Grid.ColumnDefinitions>
                    
                    <TextBlock Grid.Column="0" Text="🔍" FontSize="14" VerticalAlignment="Center" Margin="0,0,8,0"/>
                    <TextBox x:Name="SearchBox" Grid.Column="1" Background="#FF1E1E1E" Foreground="#FFFFFFFF" 
                            BorderBrush="#FF555555" BorderThickness="1" FontSize="12" Padding="8,6"
                            VerticalContentAlignment="Center" Style="{StaticResource RoundedTextBoxStyle}"
                            ToolTip="Search through events..."/>
                    
                    <Button x:Name="RefreshButton" Grid.Column="2" Content="🔄 Refresh" 
                            Background="#FF0E639C" Foreground="White" BorderThickness="0" 
                            FontSize="12" FontWeight="SemiBold" Padding="15,6" Margin="10,0,0,0"
                            Style="{StaticResource RoundedButtonStyle}" Height="30"
                            ToolTip="Refresh events (Ctrl+R)"/>
                    
                    <Button x:Name="ExportButton" Grid.Column="3" Content="📊 Export" 
                            Background="#FF388A34" Foreground="White" BorderThickness="0" 
                            FontSize="12" FontWeight="SemiBold" Padding="15,6" Margin="10,0,0,0"
                            Style="{StaticResource RoundedButtonStyle}" Height="30"
                            ToolTip="Export results to CSV"/>
                </Grid>
            </Border>
            
            <!-- Main Content Area -->
            <Border Grid.Row="2" Background="#FF1E1E1E" Margin="10,0,10,10" CornerRadius="0,0,5,5" BorderBrush="#FF3E3E40" BorderThickness="1">
                <Grid>
                    <Grid.RowDefinitions>
                        <RowDefinition Height="Auto"/>
                        <RowDefinition Height="*"/>
                    </Grid.RowDefinitions>
                    
                    <!-- Summary Stats -->
                    <Border Grid.Row="0" Background="#FF2A2A2C" Margin="10,10,10,5" CornerRadius="3" BorderBrush="#FF404040" BorderThickness="1">
                        <StackPanel Orientation="Horizontal" Margin="10,5">
                            <StackPanel Orientation="Horizontal" Margin="0,0,20,0">
                                <TextBlock Text="📊" FontSize="12" VerticalAlignment="Center" Margin="0,0,5,0"/>
                                <TextBlock x:Name="TotalEventsText" Text="Total: 0" Foreground="#FFCCCCCC" FontSize="11" VerticalAlignment="Center"/>
                            </StackPanel>
                            <StackPanel Orientation="Horizontal" Margin="0,0,20,0">
                                <TextBlock Text="⚠️" FontSize="12" VerticalAlignment="Center" Margin="0,0,5,0"/>
                                <TextBlock x:Name="SuspiciousEventsText" Text="Medium+ Risk: 0" Foreground="#FFFF6B6B" FontSize="11" VerticalAlignment="Center"/>
                            </StackPanel>
                            <StackPanel Orientation="Horizontal" Margin="0,0,20,0">
                                <TextBlock Text="🔍" FontSize="12" VerticalAlignment="Center" Margin="0,0,5,0"/>
                                <TextBlock x:Name="FilteredEventsText" Text="Showing: 0" Foreground="#FF4EC1B4" FontSize="11" VerticalAlignment="Center"/>
                            </StackPanel>
                        </StackPanel>
                    </Border>
                    
                    <!-- Events ListView -->
                    <ListView x:Name="EventsListView" Grid.Row="1" Background="Transparent" Foreground="#FFCCCCCC" 
                             BorderThickness="0" ScrollViewer.HorizontalScrollBarVisibility="Auto" 
                             ScrollViewer.VerticalScrollBarVisibility="Auto" Margin="10,0,10,10">
                        <ListView.Resources>
                            <Style TargetType="ListViewItem">
                                <Setter Property="Background" Value="Transparent"/>
                                <Setter Property="BorderThickness" Value="0"/>
                                <Setter Property="Padding" Value="8,6"/>
                                <Setter Property="Margin" Value="0,1"/>
                                <Setter Property="FocusVisualStyle" Value="{x:Null}"/>
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
                                    <Trigger Property="IsMouseOver" Value="True">
                                        <Setter Property="Background" Value="#FF2A2A2C"/>
                                    </Trigger>
                                    <Trigger Property="IsSelected" Value="True">
                                        <Setter Property="Background" Value="#FF0E639C"/>
                                    </Trigger>
                                </Style.Triggers>
                            </Style>
                        </ListView.Resources>
                        
                        <ListView.View>
                            <GridView>
                                <GridViewColumn Header="Time" Width="140">
                                    <GridViewColumn.CellTemplate>
                                        <DataTemplate>
                                            <TextBlock Text="{Binding TimeCreated}" Foreground="#FFCCCCCC" FontSize="11" ToolTip="{Binding TimeCreated}"/>
                                        </DataTemplate>
                                    </GridViewColumn.CellTemplate>
                                </GridViewColumn>
                                <GridViewColumn Header="Event ID" Width="80">
                                    <GridViewColumn.CellTemplate>
                                        <DataTemplate>
                                            <Border Background="{Binding SeverityColor}" CornerRadius="3" Padding="4,2" HorizontalAlignment="Left">
                                                <TextBlock Text="{Binding Id}" Foreground="White" FontSize="10" FontWeight="SemiBold" HorizontalAlignment="Center"/>
                                            </Border>
                                        </DataTemplate>
                                    </GridViewColumn.CellTemplate>
                                </GridViewColumn>
                                <GridViewColumn Header="Application" Width="200">
                                    <GridViewColumn.CellTemplate>
                                        <DataTemplate>
                                            <StackPanel Orientation="Horizontal">
                                                <TextBlock Text="{Binding AppIcon}" FontSize="12" VerticalAlignment="Center" Margin="0,0,5,0"/>
                                                <TextBlock Text="{Binding AppName}" Foreground="#FFCCCCCC" FontSize="11" TextWrapping="Wrap" 
                                                          ToolTip="{Binding AppName}" VerticalAlignment="Center"/>
                                            </StackPanel>
                                        </DataTemplate>
                                    </GridViewColumn.CellTemplate>
                                </GridViewColumn>
                                <GridViewColumn Header="Path" Width="250">
                                    <GridViewColumn.CellTemplate>
                                        <DataTemplate>
                                            <TextBlock Text="{Binding AppPath}" Foreground="#FF999999" FontSize="10" TextWrapping="Wrap" 
                                                      ToolTip="{Binding AppPath}" FontFamily="Consolas"/>
                                        </DataTemplate>
                                    </GridViewColumn.CellTemplate>
                                </GridViewColumn>
                                <GridViewColumn Header="Module" Width="180">
                                    <GridViewColumn.CellTemplate>
                                        <DataTemplate>
                                            <TextBlock Text="{Binding ModuleName}" Foreground="#FFCCCCCC" FontSize="11" TextWrapping="Wrap" 
                                                      ToolTip="{Binding ModuleName}"/>
                                        </DataTemplate>
                                    </GridViewColumn.CellTemplate>
                                </GridViewColumn>
                                <GridViewColumn Header="Module Path" Width="250">
                                    <GridViewColumn.CellTemplate>
                                        <DataTemplate>
                                            <TextBlock Text="{Binding ModulePath}" Foreground="#FF999999" FontSize="10" TextWrapping="Wrap" 
                                                      ToolTip="{Binding ModulePath}" FontFamily="Consolas"/>
                                        </DataTemplate>
                                    </GridViewColumn.CellTemplate>
                                </GridViewColumn>
                                <GridViewColumn Header="Risk" Width="80">
                                    <GridViewColumn.CellTemplate>
                                        <DataTemplate>
                                            <Border Background="{Binding RiskColor}" CornerRadius="3" Padding="6,2" HorizontalAlignment="Left">
                                                <TextBlock Text="{Binding RiskLevel}" Foreground="White" FontSize="10" FontWeight="SemiBold" 
                                                          HorizontalAlignment="Center"/>
                                            </Border>
                                        </DataTemplate>
                                    </GridViewColumn.CellTemplate>
                                </GridViewColumn>
                                <GridViewColumn Header="Count" Width="80">
                                    <GridViewColumn.CellTemplate>
                                        <DataTemplate>
                                            <TextBlock Text="{Binding EventCount}" Foreground="#FFFFA07A" FontSize="11" HorizontalAlignment="Center"/>
                                        </DataTemplate>
                                    </GridViewColumn.CellTemplate>
                                </GridViewColumn>
                            </GridView>
                        </ListView.View>
                    </ListView>
                </Grid>
            </Border>
            
            <!-- Status Bar -->
            <Border Grid.Row="3" Background="#FF2D2D30" CornerRadius="0,0,10,10">
                <Grid>
                    <TextBlock x:Name="StatusText" Foreground="#FFCCCCCC" FontSize="11" VerticalAlignment="Center" 
                              Margin="15,0,0,0" Text="Ready - Loaded 0 events"/>
                    <TextBlock x:Name="VersionText" Foreground="#FF666666" FontSize="10" VerticalAlignment="Center" 
                              HorizontalAlignment="Right" Margin="0,0,15,0" Text="v2.1 • Suspicious Event Parser"/>
                </Grid>
            </Border>
        </Grid>
    </Border>
</Window>
'@

# Parse XAML
try {
    $reader = New-Object System.Xml.XmlNodeReader ([xml]$xaml)
    $window = [Windows.Markup.XamlReader]::Load($reader)
} catch {
    Write-Host "Error loading XAML: $($_.Exception.Message)" -ForegroundColor Red
    return
}

# Window Controls
$minimizeButton = $window.FindName("MinimizeButton")
$maximizeButton = $window.FindName("MaximizeButton")
$closeButton = $window.FindName("CloseButton")
$refreshButton = $window.FindName("RefreshButton")
$exportButton = $window.FindName("ExportButton")

# Other controls
$eventsListView = $window.FindName("EventsListView")
$searchBox = $window.FindName("SearchBox")
$statusText = $window.FindName("StatusText")
$totalEventsText = $window.FindName("TotalEventsText")
$suspiciousEventsText = $window.FindName("SuspiciousEventsText")
$filteredEventsText = $window.FindName("FilteredEventsText")

# Enable dragging the window
$window.Add_MouseLeftButtonDown({
    if ($_.Button -eq [System.Windows.Input.MouseButton]::Left) {
        $window.DragMove()
    }
})

# Window button events
$minimizeButton.Add_Click({ $window.WindowState = [System.Windows.WindowState]::Minimized })
$maximizeButton.Add_Click({
    if ($window.WindowState -eq [System.Windows.WindowState]::Normal) {
        $window.WindowState = [System.Windows.WindowState]::Maximized
        $maximizeButton.Content = "❐"
    } else {
        $window.WindowState = [System.Windows.WindowState]::Normal
        $maximizeButton.Content = "□"
    }
})
$closeButton.Add_Click({ $window.Close() })

# Keyboard shortcuts
$window.Add_KeyDown({
    if ($_.Key -eq 'F5') {
        Load-Events
    }
    if ($_.Key -eq 'E' -and ([System.Windows.Input.Keyboard]::IsKeyDown('LeftCtrl') -or [System.Windows.Input.Keyboard]::IsKeyDown('RightCtrl'))) {
        Export-Results
    }
})

# Script-level variables
$script:baseEvents = @()
$script:currentFilteredEvents = @()

# Suspicious keywords
$keywords = @('launcher', 'settings.cock', 'external', 'cheat', 'mod', 'menu', 'loader', 'fivem', 'citizenfx', 'redengine', 'eulen', 'luna', 'hx', '9z', 'tz', 'crown', 'skript', 'nexus', 'phaze', 'inject', 'executor', 'aimbot', 'esp', 'godmode', 'teleport', 'dll')
$randomRegex = '[a-zA-Z0-9]{8,}(\.exe|\.dll)?'

# Function to parse event message and assess risk
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

    # Set defaults for missing values
    if (-not $details['AppName']) { $details['AppName'] = 'Unknown' }
    if (-not $details['AppPath']) { $details['AppPath'] = 'Unknown' }
    if (-not $details['ModuleName']) { $details['ModuleName'] = 'Unknown' }
    if (-not $details['ModulePath']) { $details['ModulePath'] = 'Unknown' }
    if (-not $details['ExceptionCode']) { $details['ExceptionCode'] = 'Unknown' }

    $details['TimeCreated'] = $event.TimeCreated.ToString("yyyy-MM-dd HH:mm:ss")
    $details['Id'] = $event.Id
    $details['FullMessage'] = $message
    $details['SeverityColor'] = if ($event.Id -eq 1002) { "#FFF39C12" } else { "#FFE74C3C" }
    $details['AppIcon'] = Get-AppIcon -appName $details['AppName']

    # Check for keywords or random app name
    $appNameLower = $details['AppName'].ToLower()
    $isDanger = $false
    foreach ($keyword in $keywords) {
        if ($appNameLower -like "*$keyword*") {
            $isDanger = $true
            break
        }
    }
    if ($appNameLower -match $randomRegex) {
        $isDanger = $true
    }

    if ($isDanger) {
        $details['RiskLevel'] = "Danger"
        $details['RiskColor'] = "#FFE74C3C"  # Red
    } else {
        # Assess risk based on other criteria
        $riskScore = 0
        if ($details['ExceptionCode'] -eq '0xc0000005') { $riskScore += 1 }  # Access Violation
        if ($details['ModulePath'] -and ($details['ModulePath'].ToLower() -match '\\temp\\' -or $details['ModulePath'].ToLower() -match '\\appdata\\' -or $details['ModulePath'].ToLower() -match '\\downloads\\')) {
            $riskScore += 1
        }
        if ($details['ModuleName'] -and $details['ModuleName'] -match '[a-zA-Z0-9]{8,}\.dll') { $riskScore += 1 }  # Random DLL
        if ($details['AppName'] -match 'FiveM' -or $details['AppPath'] -match 'FiveM' -or $details['ModuleName'] -match 'FiveM' -or $details['ModulePath'] -match 'FiveM') {
            $riskScore += 2
        }
        if ($details['ExceptionCode'] -eq '0xc0000409') { $riskScore += 1 }  # Security Check Failure
        if ($details['FaultOffset'] -and [Convert]::ToInt64($details['FaultOffset'], 16) -gt 0) { $riskScore += 1 }
        if (-not $details['ModulePath']) { $riskScore += 1 }  # Missing module path

        # Assign risk level and color
        if ($riskScore -ge 5) {
            $details['RiskLevel'] = "Danger"
            $details['RiskColor'] = "#FFE74C3C"  # Red
        } elseif ($riskScore -ge 3) {
            $details['RiskLevel'] = "High"
            $details['RiskColor'] = "#FFFFA07A"  # Orange
        } elseif ($riskScore -ge 2) {
            $details['RiskLevel'] = "Medium"
            $details['RiskColor'] = "#FFF39C12"  # Yellow
        } elseif ($riskScore -ge 1) {
            $details['RiskLevel'] = "Low"
            $details['RiskColor'] = "#FF2ECC71"  # Green
        } else {
            $details['RiskLevel'] = "Info"
            $details['RiskColor'] = "#FF3498DB"  # Blue
        }
    }

    return $details
}

# Function to get application icon
function Get-AppIcon {
    param($appName)
    
    $icons = @{
        'svchost' = '🖥️'; 'explorer' = '📁'; 'cmd' = '⌨️'; 'powershell' = '⌨️';
        'chrome' = '🌐'; 'firefox' = '🌐'; 'edge' = '🌐';
        'notepad' = '📄'; 'calculator' = '🔢';
        'steam' = '🎮'; 'epic' = '🎮'; 'fivem' = '🎮';
        'citizenfx' = '🎮'; 'redengine' = '⚠️'; 'eulen' = '⚠️'; 'luna' = '⚠️';
        'hx' = '⚠️'; '9z' = '⚠️'; 'tz' = '⚠️'; 'crown' = '⚠️';
        'skript' = '⚠️'; 'nexus' = '⚠️'; 'phaze' = '⚠️'
    }
    
    $appLower = $appName.ToLower()
    foreach ($key in $icons.Keys) {
        if ($appLower -like "*$key*") {
            return $icons[$key]
        }
    }
    
    return '⚙️'
}

# Function to show detailed window
function Show-DetailWindow {
    param ($details)

    $detailXaml = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Event Details" Width="800" Height="600"
        WindowStartupLocation="CenterOwner" Background="#FF252526">
    <Border Margin="15" BorderBrush="#FF3F3F41" BorderThickness="1" CornerRadius="5">
        <ScrollViewer VerticalScrollBarVisibility="Auto">
            <StackPanel Margin="15">
                <TextBlock Text="📋 Event Information" FontWeight="Bold" FontSize="14" Foreground="#FFE4E4E4" Margin="0,0,0,10"/>
                <Border Background="#FF2D2D30" CornerRadius="5" Padding="10" Margin="0,0,0,15">
                    <Grid>
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="150"/>
                            <ColumnDefinition Width="*"/>
                        </Grid.ColumnDefinitions>
                        <Grid.RowDefinitions>
                            <RowDefinition Height="Auto"/>
                            <RowDefinition Height="Auto"/>
                            <RowDefinition Height="Auto"/>
                            <RowDefinition Height="Auto"/>
                            <RowDefinition Height="Auto"/>
                            <RowDefinition Height="Auto"/>
                            <RowDefinition Height="Auto"/>
                            <RowDefinition Height="Auto"/>
                            <RowDefinition Height="Auto"/>
                            <RowDefinition Height="Auto"/>
                            <RowDefinition Height="Auto"/>
                            <RowDefinition Height="Auto"/>
                        </Grid.RowDefinitions>
                        
                        <TextBlock Grid.Row="0" Grid.Column="0" Text="🕒 Time:" FontWeight="SemiBold" FontSize="11" Foreground="#FFCCCCCC" Margin="0,0,10,5"/>
                        <TextBlock Grid.Row="0" Grid.Column="1" Text="{Binding TimeCreated}" FontSize="11" Foreground="#FFE4E4E4" TextWrapping="Wrap" Margin="0,0,0,5"/>
                        
                        <TextBlock Grid.Row="1" Grid.Column="0" Text="🔢 Event ID:" FontWeight="SemiBold" FontSize="11" Foreground="#FFCCCCCC" Margin="0,0,10,5"/>
                        <TextBlock Grid.Row="1" Grid.Column="1" Text="{Binding Id}" FontSize="11" Foreground="#FFE4E4E4" Margin="0,0,0,5"/>
                        
                        <TextBlock Grid.Row="2" Grid.Column="0" Text="📱 Application:" FontWeight="SemiBold" FontSize="11" Foreground="#FFCCCCCC" Margin="0,0,10,5"/>
                        <TextBlock Grid.Row="2" Grid.Column="1" Text="{Binding AppName}" FontSize="11" Foreground="#FFE4E4E4" TextWrapping="Wrap" Margin="0,0,0,5"/>
                        
                        <TextBlock Grid.Row="3" Grid.Column="0" Text="📁 Application Path:" FontWeight="SemiBold" FontSize="11" Foreground="#FFCCCCCC" Margin="0,0,10,5"/>
                        <TextBlock Grid.Row="3" Grid.Column="1" Text="{Binding AppPath}" FontSize="11" Foreground="#FFE4E4E4" TextWrapping="Wrap" Margin="0,0,0,5"/>
                        
                        <TextBlock Grid.Row="4" Grid.Column="0" Text="🔧 Module:" FontWeight="SemiBold" FontSize="11" Foreground="#FFCCCCCC" Margin="0,0,10,5"/>
                        <TextBlock Grid.Row="4" Grid.Column="1" Text="{Binding ModuleName}" FontSize="11" Foreground="#FFE4E4E4" TextWrapping="Wrap" Margin="0,0,0,5"/>
                        
                        <TextBlock Grid.Row="5" Grid.Column="0" Text="📂 Module Path:" FontWeight="SemiBold" FontSize="11" Foreground="#FFCCCCCC" Margin="0,0,10,5"/>
                        <TextBlock Grid.Row="5" Grid.Column="1" Text="{Binding ModulePath}" FontSize="11" Foreground="#FFE4E4E4" TextWrapping="Wrap" Margin="0,0,0,5"/>
                        
                        <TextBlock Grid.Row="6" Grid.Column="0" Text="⚙️ Exception Code:" FontWeight="SemiBold" FontSize="11" Foreground="#FFCCCCCC" Margin="0,0,10,5"/>
                        <TextBlock Grid.Row="6" Grid.Column="1" Text="{Binding ExceptionCode}" FontSize="11" Foreground="#FFE4E4E4" Margin="0,0,0,5"/>
                        
                        <TextBlock Grid.Row="7" Grid.Column="0" Text="📍 Fault Offset:" FontWeight="SemiBold" FontSize="11" Foreground="#FFCCCCCC" Margin="0,0,10,5"/>
                        <TextBlock Grid.Row="7" Grid.Column="1" Text="{Binding FaultOffset}" FontSize="11" Foreground="#FFE4E4E4" Margin="0,0,0,5"/>
                        
                        <TextBlock Grid.Row="8" Grid.Column="0" Text="🔢 Process ID:" FontWeight="SemiBold" FontSize="11" Foreground="#FFCCCCCC" Margin="0,0,10,5"/>
                        <TextBlock Grid.Row="8" Grid.Column="1" Text="{Binding ProcessId}" FontSize="11" Foreground="#FFE4E4E4" Margin="0,0,0,5"/>
                        
                        <TextBlock Grid.Row="9" Grid.Column="0" Text="📜 Report ID:" FontWeight="SemiBold" FontSize="11" Foreground="#FFCCCCCC" Margin="0,0,10,5"/>
                        <TextBlock Grid.Row="9" Grid.Column="1" Text="{Binding ReportId}" FontSize="11" Foreground="#FFE4E4E4" Margin="0,0,0,5"/>
                        
                        <TextBlock Grid.Row="10" Grid.Column="0" Text="🖼️ Window Title:" FontWeight="SemiBold" FontSize="11" Foreground="#FFCCCCCC" Margin="0,0,10,5"/>
                        <TextBlock Grid.Row="10" Grid.Column="1" Text="{Binding WindowTitle}" FontSize="11" Foreground="#FFE4E4E4" Margin="0,0,0,5"/>
                        
                        <TextBlock Grid.Row="11" Grid.Column="0" Text="⚠️ Risk Level:" FontWeight="SemiBold" FontSize="11" Foreground="#FFCCCCCC" Margin="0,0,10,5"/>
                        <Border Grid.Row="11" Grid.Column="1" Background="{Binding RiskColor}" CornerRadius="3" Padding="6,2" HorizontalAlignment="Left">
                            <TextBlock Text="{Binding RiskLevel}" Foreground="White" FontSize="10" FontWeight="SemiBold"/>
                        </Border>
                    </Grid>
                </Border>
                
                <TextBlock Text="📜 Full Event Message" FontWeight="Bold" FontSize="14" Foreground="#FFE4E4E4" Margin="0,15,0,10"/>
                <TextBox Text="{Binding FullMessage}" IsReadOnly="True" TextWrapping="Wrap" Height="150" 
                         Background="#FF1E1E1E" Foreground="#FFE4E4E4" BorderThickness="1" 
                         BorderBrush="#FF3F3F41" FontSize="10" Padding="8" FontFamily="Consolas" 
                         VerticalScrollBarVisibility="Auto"/>
            </StackPanel>
        </ScrollViewer>
    </Border>
</Window>
'@

    try {
        $detailReader = New-Object System.Xml.XmlNodeReader ([xml]$detailXaml)
        $detailWindow = [Windows.Markup.XamlReader]::Load($detailReader)
        $detailWindow.WindowStartupLocation = [System.Windows.WindowStartupLocation]::CenterOwner
        $detailWindow.Owner = $window
        $detailWindow.DataContext = New-Object -TypeName PSObject -Property $details
        $detailWindow.ShowDialog() | Out-Null
    } catch {
        Write-Host "Error loading detail window: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Enhanced event loading
function Load-Events {
    $statusText.Text = "🔄 Loading events..."
    $window.Cursor = [System.Windows.Input.Cursors]::Wait
    
    try {
        $events = Get-WinEvent -FilterHashtable @{LogName='Application'; ID=1000,1002} -MaxEvents 50000 -ErrorAction SilentlyContinue
        $filteredEvents = @()
        $riskyCount = 0
        
        foreach ($event in $events) {
            $details = Parse-EventMessage -message $event.Message -event $event
            
            $item = [PSCustomObject]@{
                TimeCreated = $details.TimeCreated
                Id = $details.Id
                AppName = $details.AppName
                AppPath = $details.AppPath
                ModuleName = $details.ModuleName
                ModulePath = $details.ModulePath
                RiskLevel = $details.RiskLevel
                RiskColor = $details.RiskColor
                SeverityColor = $details.SeverityColor
                AppIcon = $details.AppIcon
                EventCount = 1
                Details = $details
            }
            
            $filteredEvents += $item
            if ($details.RiskLevel -in @("Medium", "High", "Danger")) {
                $riskyCount++
            }
        }
        
        # Remove duplicates and count occurrences
        $groupedEvents = $filteredEvents | Group-Object -Property AppName, AppPath, ModuleName, ModulePath
        $script:baseEvents = $groupedEvents | ForEach-Object {
            $firstEvent = $_.Group | Sort-Object TimeCreated -Descending | Select-Object -First 1
            [PSCustomObject]@{
                TimeCreated = $firstEvent.TimeCreated
                Id = $firstEvent.Id
                AppName = $firstEvent.AppName
                AppPath = $firstEvent.AppPath
                ModuleName = $firstEvent.ModuleName
                ModulePath = $firstEvent.ModulePath
                RiskLevel = $firstEvent.RiskLevel
                RiskColor = $firstEvent.RiskColor
                SeverityColor = $firstEvent.SeverityColor
                AppIcon = $firstEvent.AppIcon
                EventCount = $_.Count
                Details = $firstEvent.Details
            }
        }
        
        $script:baseEvents = $script:baseEvents | Sort-Object TimeCreated -Descending
        $script:currentFilteredEvents = $script:baseEvents
        
        $eventsListView.ItemsSource = $script:currentFilteredEvents
        
        $totalEventsText.Text = "Total: $($events.Count)"
        $suspiciousEventsText.Text = "Medium+ Risk: $riskyCount"
        $filteredEventsText.Text = "Showing: $($script:currentFilteredEvents.Count)"
        $statusText.Text = "✅ Loaded $($events.Count) total events ($riskyCount medium+ risk)"
    }
    catch {
        $statusText.Text = "❌ Error loading events: $($_.Exception.Message)"
    }
    finally {
        $window.Cursor = [System.Windows.Input.Cursors]::Arrow
    }
}

# Export function
function Export-Results {
    if ($script:currentFilteredEvents.Count -eq 0) {
        $statusText.Text = "⚠️ No events to export"
        return
    }
    
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $filename = "SuspiciousEvents_$timestamp.csv"
    
    $exportData = $script:currentFilteredEvents | ForEach-Object {
        [PSCustomObject]@{
            TimeCreated = $_.TimeCreated
            EventID = $_.Id
            Application = $_.AppName
            Path = $_.AppPath
            Module = $_.ModuleName
            ModulePath = $_.ModulePath
            RiskLevel = $_.RiskLevel
            EventCount = $_.EventCount
            FullMessage = $_.Details.FullMessage
        }
    }
    
    $exportData | Export-Csv -Path $filename -NoTypeInformation
    $statusText.Text = "📁 Exported $($exportData.Count) events to $filename"
}

# Search functionality
$searchBox.Add_TextChanged({
    $searchText = $searchBox.Text.ToLower()
    if ([string]::IsNullOrEmpty($searchText)) {
        $script:currentFilteredEvents = $script:baseEvents
    } else {
        $script:currentFilteredEvents = $script:baseEvents | Where-Object {
            ($_.AppName -and $_.AppName.ToLower().Contains($searchText)) -or
            ($_.AppPath -and $_.AppPath.ToLower().Contains($searchText)) -or
            ($_.ModuleName -and $_.ModuleName.ToLower().Contains($searchText)) -or
            ($_.ModulePath -and $_.ModulePath.ToLower().Contains($searchText)) -or
            ($_.Details.FullMessage.ToLower().Contains($searchText)) -or
            ($_.RiskLevel.ToLower().Contains($searchText))
        }
    }
    $eventsListView.ItemsSource = $script:currentFilteredEvents
    $filteredEventsText.Text = "Showing: $($script:currentFilteredEvents.Count)"
})

# Button events
$refreshButton.Add_Click({ Load-Events })
$exportButton.Add_Click({ Export-Results })

# Double-click for details
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

# End of script
