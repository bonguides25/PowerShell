# --- Assemblies ---
<# Add-Type -AssemblyName PresentationCore, PresentationFramework, WindowsBase, System.Xaml
[System.Windows.Forms.Application]::EnableVisualStyles() | Out-Null #>

Add-Type -AssemblyName PresentationCore, PresentationFramework, WindowsBase, System.Xaml, System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles() | Out-Null


# --- XAML ---
$xamlInput = @'
<Window x:Class="unattended.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:unattended"
        mc:Ignorable="d"
        Title="Installation Tool"  ResizeMode="NoResize" WindowStartupLocation="CenterScreen" ScrollViewer.CanContentScroll="True" Width="978" Height="515">
    <Grid Margin="20,20,0,0" HorizontalAlignment="Left" VerticalAlignment="Top" Height="465" Width="948">
        <Grid.ColumnDefinitions>
            <ColumnDefinition Width="133*"/>
            <ColumnDefinition Width="104*"/>
        </Grid.ColumnDefinitions>
        <Button x:Name="buttonSubmit" Content="Submit" HorizontalAlignment="Left" Margin="84,291,0,0" VerticalAlignment="Top" Width="118" Height="28" Background="#FF168E12" Foreground="White" FontFamily="Roboto" FontSize="13" FontWeight="Bold" UseLayoutRounding="True" BorderBrush="#FF168E12"/>
        <CheckBox x:Name="cb_apps" Content="Desktop Apps" HorizontalAlignment="Left" Margin="27,18,0,0" VerticalAlignment="Top" Height="15" Width="94"/>
        <CheckBox x:Name="cb_activate" Content="Activate Windows" HorizontalAlignment="Left" Margin="27,47,0,0" VerticalAlignment="Top" Height="15" Width="114"/>
        <TextBox x:Name="textbox" HorizontalAlignment="Left" Margin="16,197,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="263" Height="18"/>
        <TextBox x:Name="textbox1" HorizontalAlignment="Left" Margin="16,235,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="263" Height="18"/>
        <CheckBox x:Name="cb_office" Content="Install Office" HorizontalAlignment="Left" Margin="27,75,0,0" VerticalAlignment="Top" Height="15" Width="86"/>
        <CheckBox x:Name="cb_config" Content="Configure" HorizontalAlignment="Left" Margin="27,106,0,0" VerticalAlignment="Top" Height="15" Width="72"/>
        <CheckBox x:Name="cb_cursor" Content="Mouse Pointer (Green)" HorizontalAlignment="Left" Margin="27,139,0,0" VerticalAlignment="Top" Height="15" Width="139"/>
        <CheckBox x:Name="cb_cursor_orange" Content="Mouse Pointer (Orange)" HorizontalAlignment="Left" Margin="185,139,0,0" VerticalAlignment="Top" Height="15" Width="147"/>
        <CheckBox x:Name="cb_cursor_reset" Content="Mouse Pointer (Reset)" Margin="355,139,0,0" VerticalAlignment="Top" Height="15" HorizontalAlignment="Left" Width="139"/>
        <CheckBox x:Name="cb_wall0" Content="Desktop Wallpaper" HorizontalAlignment="Left" Margin="143,18,0,0" VerticalAlignment="Top" Height="15" Width="123"/>

    </Grid>
</Window>

'@

# --- Parse XAML ---
[xml]$xaml = $xamlInput -replace '^<Window.*','<Window' -replace 'mc:Ignorable="d"','' -replace 'x:Name','Name'
$xmlReader = New-Object System.Xml.XmlNodeReader $xaml
$Form = [Windows.Markup.XamlReader]::Load($xmlReader)

$xaml.SelectNodes('//*[@Name]') | ForEach-Object {
  Set-Variable -Name ($_.Name) -Value $Form.FindName($_.Name) -Scope Script
}

# --- Runspace (create BEFORE sharing) ---
$runspace = [RunspaceFactory]::CreateRunspace()
$runspace.ApartmentState = 'STA'
$runspace.ThreadOptions  = 'ReuseThread'
$runspace.Open()

# --- Shared state for UI thread marshaling ---
$sync = [hashtable]::Synchronized(@{
    host          = $Host
    Form          = $Form
    buttonSubmit  = $buttonSubmit
    textbox       = $textbox
    textbox1      = $textbox1
})
$runspace.SessionStateProxy.SetVariable('sync', $sync)

# --- Click handler: disable button, run steps async, re-enable on completion ---
$buttonSubmit.Add_Click({
    # Build ordered steps: each has a status and a cmd string
    $steps = @()
    if ($cb_apps.IsChecked) {
        $steps += [pscustomobject]@{
            status = 'Installing desktop apps...'
            cmd    = 'irm bonguides.com/desktop-apps | iex'
        }
    }
    if ($cb_activate.IsChecked) {
        $steps += [pscustomobject]@{
            status = 'Activating Windows...'
            cmd    = 'irm win.msgang.com | iex'
        }
    }
    if ($cb_office.IsChecked) {
        $steps += [pscustomobject]@{
            status = 'Installing Office...'
            cmd    = 'irm install.msgang.com | iex'
        }
    }

    if ($cb_config.IsChecked) {
        $steps += [pscustomobject]@{
            status = 'Customizing Windows...'
            cmd    = 'irm bonguides.com/config | iex'
        }
    }

    if ($cb_cursor.IsChecked) {
        $steps += [pscustomobject]@{
            status = 'Customizing Windows...'
            cmd    = 'irm https://github.com/bonguides25/PowerShell/raw/refs/heads/main/Windows_Customizations/Files/Cursors/cursor-add.ps1 | iex'
        }
    }

    if ($cb_cursor_orange.IsChecked) {
        $steps += [pscustomobject]@{
            status = 'Customizing Windows...'
            cmd    = 'irm https://github.com/bonguides25/PowerShell/raw/refs/heads/main/Windows_Customizations/Files/Cursors/add-cursor-orange.ps1 | iex'
        }
    }

    if ($cb_cursor_reset.IsChecked) {
        $steps += [pscustomobject]@{
            status = 'Customizing Windows...'
            cmd    = 'irm https://github.com/bonguides25/PowerShell/raw/refs/heads/main/Windows_Customizations/Files/Cursors/reset-cursor.ps1 | iex'
        }
    }

    if ($cb_wall0.IsChecked) {
        $steps += [pscustomobject]@{
            status = 'Settings Wallpaper...'
            cmd    = 'irm https://github.com/bonguides25/PowerShell/raw/refs/heads/main/Windows_Customizations/Scripts/wallpaper.ps1 | iex'
        }
    }


    # UI: disable while running
    $buttonSubmit.IsEnabled = $false
    $buttonSubmit.Content   = 'Running...'
    $textbox.Text           = $steps[0].status
    $textbox1.Text          = $steps[0].cmd

    # Background scriptblock that iterates steps and updates UI safely
    $worker = {
        param($sync, $steps)
        foreach ($step in $steps) {
            # Update status/command on UI thread
            $null = $sync.Form.Dispatcher.Invoke([action]{
                $sync.textbox.Text  = $step.status
                $sync.textbox1.Text = $step.cmd
            })

            # Execute the command text in the runspace
            Invoke-Expression $step.cmd
        }
    }

    # Start async pipeline
    $ps = [PowerShell]::Create().AddScript($worker).AddArgument($sync).AddArgument($steps)
    $ps.Runspace = $runspace
    $ps.BeginInvoke()

    # Re-enable button and finalize UI when done
    $buttonSubmit.IsEnabled = $true
})

# --- Show Window ---
$null = $Form.ShowDialog()
