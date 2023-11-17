<# Name       : Microsoft Office Download/Install for Free by Leo ( For Windows 10/11)
Windows 10    : For Windows 7/8/8.1 the script can be found at https://bonguides.com/office7
Description   : Download and Install all Offices Editions for free without any software.
Website       : https://bonguides.com
Script by     : Leo Nguyen #>

if (-not([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "You need to have Administrator rights to run this script!`nPlease re-run this script as an Administrator in an elevated powershell prompt!"
    Start-Process -Verb runas -FilePath powershell.exe -ArgumentList "irm bonguides.com/office | iex"
    break
}

# Load ddls to the current session.
Add-Type -AssemblyName PresentationFramework, System.Drawing, PresentationFramework, System.Windows.Forms, WindowsFormsIntegration, PresentationCore
[System.Windows.Forms.Application]::EnableVisualStyles()

# Place your xaml code from Visual Studio in here string (between @ symbols)
# $xamlinput = @'<xaml code here'@

$xamlInput = @'
<Window x:Class="installer.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:installer"
        mc:Ignorable="d"
        Title="Microsoft Installation Tool - www.bonguides.com" Height="515" Width="970" WindowStartupLocation="CenterScreen" Icon="https://filedn.com/lOX1R8Sv7vhpEG9Q77kMbn0/MSGANG/PowerShell/images/msgang_microsoft_icon.png">
    <Grid HorizontalAlignment="Left" VerticalAlignment="Top">
        <GroupBox x:Name="groupBoxMicrosoftOffice" Header="Select version to install:" BorderBrush="#FF164A69" Margin="125,10,0,0" HorizontalAlignment="Left" VerticalAlignment="Top" Height="458" Width="821" FontFamily="Consolas" FontSize="11">
            <Canvas HorizontalAlignment="Left" VerticalAlignment="Top">
                <Rectangle Height="81" Stroke="#FF164A69" Width="135" UseLayoutRounding="True" RadiusX="5" RadiusY="5" Canvas.Left="11" Canvas.Top="20" HorizontalAlignment="Center" VerticalAlignment="Top"/>
                <RadioButton x:Name="radioButton365Home" Content="Home" Canvas.Left="19" Canvas.Top="35" HorizontalAlignment="Left" VerticalAlignment="Top" VerticalContentAlignment="Center" Margin="0,5,0,0"/>
                <RadioButton x:Name="radioButton365Business" Content="Business" Canvas.Left="19" Canvas.Top="54" HorizontalAlignment="Left" VerticalAlignment="Center" HorizontalContentAlignment="Center" VerticalContentAlignment="Center" Margin="0,5,0,0"/>
                <RadioButton x:Name="radioButton365Enterprise" Content="Enterprise" Canvas.Left="19" Canvas.Top="73" HorizontalAlignment="Left" VerticalAlignment="Top" VerticalContentAlignment="Center" Margin="0,5,0,0"/>
                <Rectangle Height="306" Stroke="#FF164A69" Width="150" UseLayoutRounding="True" RadiusX="5" RadiusY="5" Canvas.Left="159" Canvas.Top="20" HorizontalAlignment="Center" VerticalAlignment="Top"/>
                <RadioButton x:Name="radioButton2021Pro" Content="Professional" VerticalContentAlignment="Center" HorizontalAlignment="Left" VerticalAlignment="Top" Canvas.Left="172" Canvas.Top="35" Margin="0,5,0,0"/>
                <RadioButton x:Name="radioButton2021Std" Content="Standard" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Left="172" Canvas.Top="50" HorizontalAlignment="Left" VerticalAlignment="Center" Margin="0,5,0,0"/>
                <RadioButton x:Name="radioButton2021ProjectPro" Content="Project Pro" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Left="172" Canvas.Top="69" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="0,5,0,0"/>
                <RadioButton x:Name="radioButton2021ProjectStd" Content="Project Standard" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Left="172" Canvas.Top="87" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="0,5,0,0"/>
                <RadioButton x:Name="radioButton2021VisioPro" Content="Visio Pro" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Left="172" Canvas.Top="107" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="0,5,0,0"/>
                <RadioButton x:Name="radioButton2021VisioStd" Content="Visio Standard" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Left="172" Canvas.Top="127" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="0,5,0,0"/>
                <RadioButton x:Name="radioButton2021Word" Content="Word" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Left="172" Canvas.Top="147" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="0,5,0,0"/>
                <RadioButton x:Name="radioButton2021Excel" Content="Excel" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Left="172" Canvas.Top="167" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="0,5,0,0"/>
                <RadioButton x:Name="radioButton2021PowerPoint" Content="PowerPoint" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Left="172" Canvas.Top="187" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="0,5,0,0"/>
                <RadioButton x:Name="radioButton2021Outlook" Content="Outlook" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Left="172" Canvas.Top="207" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="0,5,0,0"/>
                <RadioButton x:Name="radioButton2021Access" Content="Access" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Left="172" Canvas.Top="227" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="0,5,0,0"/>
                <RadioButton x:Name="radioButton2021Publisher" Content="Publisher" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Left="172" Canvas.Top="247" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="0,5,0,0"/>
                <RadioButton x:Name="radioButton2021HomeStudent" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Left="172" Canvas.Top="267" Content="HomeStudent" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="0,5,0,0"/>
                <RadioButton x:Name="radioButton2021HomeBusiness" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Left="172" Canvas.Top="290" Content="HomeBusiness" HorizontalAlignment="Left" VerticalAlignment="Center" Margin="0,5,0,0"/>
                <Rectangle Height="306" Stroke="#FF164A69" Width="150" UseLayoutRounding="True" RadiusX="5" RadiusY="5" Canvas.Left="325" Canvas.Top="20" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <RadioButton x:Name="radioButton2019Pro" Content="Professional" IsChecked="False" Padding="5,5,5,5" Canvas.Left="330" Canvas.Top="30" VerticalContentAlignment="Center" VerticalAlignment="Center" Margin="5,5,0,0"/>
                <RadioButton x:Name="radioButton2019Std" Content="Standard" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Left="330" Canvas.Top="50" VerticalAlignment="Center" Margin="5,5,0,0"/>
                <RadioButton x:Name="radioButton2019ProjectPro" Content="Project Pro" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Left="330" Canvas.Top="70" HorizontalAlignment="Center" VerticalAlignment="Center" Margin="5,5,0,0"/>
                <RadioButton x:Name="radioButton2019ProjectStd" Content="Project Standard" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Left="330" Canvas.Top="90" HorizontalAlignment="Center" VerticalAlignment="Center" Margin="5,5,0,0"/>
                <RadioButton x:Name="radioButton2019VisioPro" Content="Visio Pro" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Left="330" Canvas.Top="110" HorizontalAlignment="Center" VerticalAlignment="Center" Margin="5,5,0,0"/>
                <RadioButton x:Name="radioButton2019VisioStd" Content="Visio Standard" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Left="330" Canvas.Top="130" HorizontalAlignment="Center" VerticalAlignment="Center" Margin="5,5,0,0"/>
                <RadioButton x:Name="radioButton2019Word" Content="Word" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Left="330" Canvas.Top="150" HorizontalAlignment="Center" VerticalAlignment="Center" Margin="5,5,0,0"/>
                <RadioButton x:Name="radioButton2019Excel" Content="Excel" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Left="330" Canvas.Top="170" HorizontalAlignment="Center" VerticalAlignment="Center" Margin="5,5,0,0"/>
                <RadioButton x:Name="radioButton2019PowerPoint" Content="PowerPoint" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Left="330" Canvas.Top="190" HorizontalAlignment="Center" VerticalAlignment="Center" Margin="5,5,0,0"/>
                <RadioButton x:Name="radioButton2019Outlook" Content="Outlook" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Left="330" Canvas.Top="208" HorizontalAlignment="Center" VerticalAlignment="Center" Margin="5,5,0,0"/>
                <RadioButton x:Name="radioButton2019Access" Content="Access" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Left="330" Canvas.Top="230" HorizontalAlignment="Center" VerticalAlignment="Center" Margin="5,5,0,0"/>
                <RadioButton x:Name="radioButton2019Publisher" Content="Publisher" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Left="330" Canvas.Top="250" HorizontalAlignment="Center" VerticalAlignment="Center" Margin="5,5,0,0"/>
                <RadioButton x:Name="radioButton2019HomeStudent" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Left="330" Canvas.Top="270" Content="HomeStudent" HorizontalAlignment="Center" VerticalAlignment="Center" Margin="5,5,0,0"/>
                <RadioButton x:Name="radioButton2019HomeBusiness" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Left="330" Canvas.Top="290" Content="HomeBusiness" HorizontalAlignment="Center" VerticalAlignment="Center" Margin="5,5,0,0"/>
                <Label x:Name="Label365" Content="Office 2016" FontWeight="Bold" Canvas.Left="19" Background="#FF1C824D" HorizontalAlignment="Center" VerticalAlignment="Top" Canvas.Top="8" Foreground="White" Padding="8,4,8,4" Width="95"/>
                <Label x:Name="Label2021" Content="Office 2021" FontWeight="Bold" Canvas.Left="167" Canvas.Top="8" HorizontalAlignment="Center" VerticalAlignment="Top" Foreground="White" UseLayoutRounding="True" Padding="8,4,8,4" ScrollViewer.CanContentScroll="True" Background="#FF3C10DE"/>
                <Label x:Name="Label2019" Content="Office 2019" FontWeight="Bold" Canvas.Left="334" Background="#FF0F8E40" Canvas.Top="8" HorizontalAlignment="Left" VerticalAlignment="Center" Foreground="White" Padding="8,4,8,4"/>
                <Rectangle Height="306" Stroke="#FF164A69" Width="150" UseLayoutRounding="True" RadiusX="5" RadiusY="5" Canvas.Left="490" Canvas.Top="20" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <RadioButton x:Name="radioButton2016Pro" Content="Professional" IsChecked="False" Padding="5,5,5,5" VerticalContentAlignment="Center" Canvas.Left="498" Canvas.Top="30" HorizontalAlignment="Center" VerticalAlignment="Center" Margin="5,5,0,0"/>
                <RadioButton x:Name="radioButton2016Std" Content="Standard" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Top="50" Canvas.Left="498" HorizontalAlignment="Center" VerticalAlignment="Center" Margin="5,5,0,0"/>
                <RadioButton x:Name="radioButton2016ProjectPro" Content="Project Pro" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Top="70" Canvas.Left="498" HorizontalAlignment="Center" VerticalAlignment="Center" Margin="5,5,0,0"/>
                <RadioButton x:Name="radioButton2016ProjectStd" Content="Project Standard" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Top="90" Canvas.Left="498" HorizontalAlignment="Center" VerticalAlignment="Center" Margin="5,5,0,0"/>
                <RadioButton x:Name="radioButton2016VisioPro" Content="Visio Pro" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Top="110" Canvas.Left="498" HorizontalAlignment="Center" VerticalAlignment="Center" Margin="5,5,0,0"/>
                <RadioButton x:Name="radioButton2016VisioStd" Content="Visio Standard" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Top="130" Canvas.Left="498" HorizontalAlignment="Center" VerticalAlignment="Center" Margin="5,5,0,0"/>
                <RadioButton x:Name="radioButton2016Word" Content="Word" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Top="150" Canvas.Left="498" HorizontalAlignment="Center" VerticalAlignment="Center" Margin="5,5,0,0"/>
                <RadioButton x:Name="radioButton2016Excel" Content="Excel" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Top="170" Canvas.Left="498" HorizontalAlignment="Center" VerticalAlignment="Center" Margin="5,5,0,0"/>
                <RadioButton x:Name="radioButton2016PowerPoint" Content="PowerPoint" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Top="190" Canvas.Left="498" HorizontalAlignment="Center" VerticalAlignment="Center" Margin="5,5,0,0"/>
                <RadioButton x:Name="radioButton2016Outlook" Content="Outlook" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Top="207" Canvas.Left="498" HorizontalAlignment="Center" VerticalAlignment="Center" Margin="5,5,0,0"/>
                <RadioButton x:Name="radioButton2016Access" Content="Access" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Top="230" Canvas.Left="498" HorizontalAlignment="Center" VerticalAlignment="Center" Margin="5,5,0,0"/>
                <RadioButton x:Name="radioButton2016Publisher" Content="Publisher" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Top="250" Canvas.Left="498" HorizontalAlignment="Center" VerticalAlignment="Center" Margin="5,5,0,0"/>
                <RadioButton x:Name="radioButton2016OneNote" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Content="OneNote" Canvas.Top="270" Canvas.Left="498" HorizontalAlignment="Center" VerticalAlignment="Center" Margin="5,5,0,0"/>
                <Label x:Name="Label2016" Content="Office 2016" FontWeight="Bold" Canvas.Left="500" Background="#FFA28210" Canvas.Top="8" HorizontalAlignment="Left" VerticalAlignment="Center" Padding="8,4,8,4" Foreground="White"/>
                <Rectangle Height="306" Stroke="#FF164A69" Width="150" UseLayoutRounding="True" RadiusX="5" RadiusY="5" Canvas.Left="656" Canvas.Top="20" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <Label x:Name="Label2013" Content="Office 2013" FontWeight="Bold" Canvas.Left="667" Background="#FF1B0F0F" Canvas.Top="8" HorizontalAlignment="Left" VerticalAlignment="Center" Foreground="White" Padding="8,4,8,4"/>
                <RadioButton x:Name="radioButton2013Pro" Content="Professional" IsChecked="False" Padding="5,5,5,5" VerticalContentAlignment="Center" Canvas.Left="670" Canvas.Top="30" HorizontalAlignment="Center" VerticalAlignment="Center" Margin="-3,5,0,0"/>
                <RadioButton x:Name="radioButton2013Std" Content="Standard" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Top="50" Canvas.Left="670" HorizontalAlignment="Center" VerticalAlignment="Center" Margin="-3,5,0,0"/>
                <RadioButton x:Name="radioButton2013ProjectPro" Content="Project Pro" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Top="70" Canvas.Left="670" HorizontalAlignment="Center" VerticalAlignment="Center" Margin="-3,5,0,0"/>
                <RadioButton x:Name="radioButton2013ProjectStd" Content="Project Standard" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Top="90" Canvas.Left="670" HorizontalAlignment="Center" VerticalAlignment="Center" Margin="-3,5,0,0"/>
                <RadioButton x:Name="radioButton2013VisioPro" Content="Visio Pro" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Top="110" Canvas.Left="670" HorizontalAlignment="Center" VerticalAlignment="Center" Margin="-3,5,0,0"/>
                <RadioButton x:Name="radioButton2013VisioStd" Content="Visio Standard" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Top="130" Canvas.Left="670" HorizontalAlignment="Center" VerticalAlignment="Center" Margin="-3,5,0,0"/>
                <RadioButton x:Name="radioButton2013Word" Content="Word" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Top="150" Canvas.Left="670" HorizontalAlignment="Center" VerticalAlignment="Center" Margin="-3,5,0,0"/>
                <RadioButton x:Name="radioButton2013Excel" Content="Excel" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Top="170" Canvas.Left="670" HorizontalAlignment="Center" VerticalAlignment="Center" Margin="-3,5,0,0"/>
                <RadioButton x:Name="radioButton2013PowerPoint" Content="PowerPoint" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Top="190" Canvas.Left="670" HorizontalAlignment="Center" VerticalAlignment="Center" Margin="-3,5,0,0"/>
                <RadioButton x:Name="radioButton2013Outlook" Content="Outlook" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Top="210" Canvas.Left="670" HorizontalAlignment="Center" VerticalAlignment="Center" Margin="-3,5,0,0"/>
                <RadioButton x:Name="radioButton2013Access3" Content="Access" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Top="230" Canvas.Left="670" HorizontalAlignment="Center" VerticalAlignment="Center" Margin="-3,5,0,0"/>
                <RadioButton x:Name="radioButton2013Publisher" Content="Publisher" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Top="250" Canvas.Left="670" HorizontalAlignment="Center" VerticalAlignment="Center" Margin="-3,5,0,0"/>
                <Rectangle x:Name="RemoveAll" Stroke="#FFDC281F" UseLayoutRounding="True" RadiusX="5" RadiusY="5" Height="50" Width="316" Canvas.Top="347" Canvas.Left="490" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <RadioButton x:Name="radioButtonRemoveAllApp" Content="I Agree (Caution!)" FontFamily="Consolas" FontSize="11" VerticalContentAlignment="Center" IsChecked="False" Canvas.Left="503" Canvas.Top="366" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <TextBlock x:Name="textBoxRemoveAll" TextWrapping="Wrap" Text="(*) This option removes all install Office apps." FontSize="10.5" Canvas.Left="488" Canvas.Top="405" Foreground="#FFED551B" HorizontalAlignment="Left" VerticalAlignment="Center" FontWeight="Bold"/>
                <TextBox x:Name="textBox1" TextWrapping="Wrap" Text="(*) By default, this script installs the 64-bit version in English." Canvas.Top="338" FontSize="10.5" BorderBrush="{x:Null}" Background="{x:Null}" HorizontalAlignment="Center" VerticalAlignment="Top" Canvas.Left="-3" Margin="0,2,0,2" Padding="0,0,0,2"/>
                <TextBox x:Name="textBox2" TextWrapping="Wrap" Text="(*) Default mode is Install. If you want to download only, select Download mode." Canvas.Top="360" FontSize="10.5" BorderBrush="{x:Null}" Background="{x:Null}" HorizontalAlignment="Center" VerticalAlignment="Top" Canvas.Left="-3" Padding="0,0,0,2"/>
                <TextBox x:Name="textBox3" TextWrapping="Wrap" Text="(*) The downloaded files would be saved on the current user's desktop." Canvas.Top="377" FontSize="10.5" BorderBrush="{x:Null}" Background="{x:Null}" HorizontalAlignment="Center" VerticalAlignment="Top" Canvas.Left="-3" Padding="0,0,0,2" Margin="0,2,0,2"/>
                <TextBox x:Name="textBox4" TextWrapping="Wrap" Text="(*) The script can download/ install both Retail and Volume versions." Canvas.Top="395" FontSize="10.5" BorderBrush="{x:Null}" Background="{x:Null}" HorizontalAlignment="Center" VerticalAlignment="Top" Canvas.Left="-3" Margin="0,2,0,2" Padding="0,0,0,2"/>
                <TextBox x:Name="textBox5" TextWrapping="Wrap" Text="(*) Created by: Leo Nguyen | Website: " Canvas.Top="414" FontSize="10.5" BorderBrush="{x:Null}" Background="{x:Null}" Canvas.Left="-3" HorizontalAlignment="Center" VerticalAlignment="Top" Margin="0,2,0,2" Padding="0,0,0,2"/>
                <Label x:Name="LabelRemoveAll" Content="Remove All Apps:" FontWeight="Bold" Canvas.Left="502" Canvas.Top="334" HorizontalAlignment="Left" VerticalAlignment="Center" Background="White"/>
                <Button x:Name="buttonRemoveAll" Content="Remove All" Background="#FFE23B15" FontFamily="Consolas" FontSize="10" Foreground="White" Height="27" Width="73" UseLayoutRounding="True" BorderBrush="{x:Null}" HorizontalAlignment="Left" Canvas.Left="670" Canvas.Top="358" VerticalAlignment="Center"/>
                <Image x:Name="image" Height="81" Width="78" Canvas.Left="40" Canvas.Top="112" Source="https://filedn.com/lOX1R8Sv7vhpEG9Q77kMbn0/bg/img/form-img2.png" HorizontalAlignment="Center" VerticalAlignment="Top" Visibility="Hidden"/>
                <Image x:Name="image1" Height="79" Width="58" Canvas.Left="45" Canvas.Top="223" Source="https://filedn.com/lOX1R8Sv7vhpEG9Q77kMbn0/bg/img/form-img1.png" HorizontalAlignment="Center" VerticalAlignment="Top"/>
            </Canvas>
        </GroupBox>
        <GroupBox x:Name="groupBoxArch" Header="Arch:" Margin="10,10,0,0" BorderBrush="#FF0D4261" HorizontalAlignment="Left" VerticalAlignment="Top" FontFamily="Consolas" FontSize="11" Width="104">
            <StackPanel HorizontalAlignment="Left" VerticalAlignment="Top">
                <RadioButton x:Name="radioButtonArch64" Content="x64" Width="37" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="5,6,0,0" VerticalContentAlignment="Center" IsChecked="True"/>
                <RadioButton x:Name="radioButtonArch32" Content="x32" Width="37" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="5,6,0,5" VerticalContentAlignment="Center"/>
            </StackPanel>
        </GroupBox>
        <GroupBox x:Name="groupBoxLicenseType" Header="LicenseType:" Margin="10,87,0,0" BorderBrush="#FF0D4261" HorizontalAlignment="Left" VerticalAlignment="Top" FontFamily="Consolas" FontSize="11" Width="104" Height="65">
            <StackPanel HorizontalAlignment="Left" VerticalAlignment="Top">
                <RadioButton x:Name="radioButtonVolume" Content="Volume" HorizontalAlignment="Left" VerticalAlignment="Top" VerticalContentAlignment="Center" IsChecked="True" Margin="5,6,0,0"/>
                <RadioButton x:Name="radioButtonRetail" Content="Retail" HorizontalAlignment="Left" VerticalAlignment="Top" VerticalContentAlignment="Center" Margin="5,6,0,0"/>
            </StackPanel>
        </GroupBox>
        <GroupBox x:Name="groupBoxMode" Header="Mode:" Margin="10,161,0,0" BorderBrush="#FF0D4261" HorizontalAlignment="Left" VerticalAlignment="Top" FontFamily="Consolas" FontSize="11" Width="104" Height="67" ToolTip="When selecting the Activate mode...">
            <StackPanel HorizontalAlignment="Left" VerticalAlignment="Top">
                <RadioButton x:Name="radioButtonInstall" Content="Install" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="5,6,0,0" VerticalContentAlignment="Center" IsChecked="True"/>
                <RadioButton x:Name="radioButtonDownload" Content="Download" VerticalContentAlignment="Center" Margin="5,6,0,0"/>
            </StackPanel>
        </GroupBox>
        <GroupBox x:Name="groupBoxLanguage" Header="Language:" Margin="10,239,0,0" BorderBrush="#FF0D4261" HorizontalAlignment="Left" VerticalAlignment="Top" FontFamily="Consolas" FontSize="11" Width="104" Height="229">
            <StackPanel HorizontalAlignment="Left" VerticalAlignment="Top">
                <RadioButton x:Name="radioButtonEnglish" Content="English" VerticalContentAlignment="Center" IsChecked="True" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="5,8,0,0"/>
                <RadioButton x:Name="radioButtonJapanese" Content="Japanese" VerticalContentAlignment="Center" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="5,6,0,0"/>
                <RadioButton x:Name="radioButtonKorean" Content="Korean" VerticalContentAlignment="Center" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="5,6,0,0"/>
                <RadioButton x:Name="radioButtonChinese" Content="Chinese" VerticalContentAlignment="Center" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="5,6,0,0"/>
                <RadioButton x:Name="radioButtonFrench" Content="French" VerticalContentAlignment="Center" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="5,6,0,0"/>
                <RadioButton x:Name="radioButtonSpanish" Content="Spanish" VerticalContentAlignment="Center" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="5,6,0,0"/>
                <RadioButton x:Name="radioButtonHindi" Content="Hindi" VerticalContentAlignment="Center" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="5,6,0,0"/>
                <RadioButton x:Name="radioButtonGerman" Content="German" VerticalContentAlignment="Center" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="5,6,0,0"/>
                <RadioButton x:Name="radioButtonIndonesian" Content="Indonesian" VerticalContentAlignment="Center" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="5,6,0,0"/>
                <RadioButton x:Name="radioButtonVietnamese" Content="Vietnamese" VerticalContentAlignment="Center" Margin="5,6,0,0"/>
            </StackPanel>
        </GroupBox>
        <Button x:Name="buttonSubmit" Content="Submit" HorizontalAlignment="Left" Margin="147,187,0,0" VerticalAlignment="Top" Width="118" Height="28" Background="#FF168E12" Foreground="White" FontFamily="Consolas" FontSize="13" FontWeight="Bold" UseLayoutRounding="True" BorderBrush="#FF168E12"/>
        <ProgressBar x:Name="progressbar" HorizontalAlignment="Left" Height="10" Margin="147,226,0,0" VerticalAlignment="Top" Width="118" IsEnabled="False" Background="{x:Null}" BorderBrush="{x:Null}"/>
        <TextBox x:Name="textbox" TextWrapping="Wrap" Width="120" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="147,248,0,0" FontFamily="Consolas" FontSize="11" HorizontalContentAlignment="Center" VerticalContentAlignment="Center" Background="{x:Null}" BorderBrush="{x:Null}" AllowDrop="False" Focusable="False" IsHitTestVisible="False" IsTabStop="False" IsUndoEnabled="False"/>
        <Label x:Name="Link1" HorizontalAlignment="Left" Margin="342,436,0,0" VerticalAlignment="Top" Width="172" FontSize='10.5' FontFamily="Consolas" Padding="5,5,5,2">
            <Hyperlink NavigateUri="https://bonguides.com">https://bonguides.com</Hyperlink>
        </Label>

    </Grid>
</Window>


'@

[xml]$xaml = $xamlInput -replace '^<Window.*', '<Window' -replace 'mc:Ignorable="d"','' -replace "x:Name",'Name'
$xmlReader = (New-Object System.Xml.XmlNodeReader $xaml)
$Form = [Windows.Markup.XamlReader]::Load( $xmlReader )

# Store form objects (variables) in PowerShell
    $xaml.SelectNodes("//*[@Name]") | ForEach-Object -Process {
        Set-Variable -Name ($_.Name) -Value $Form.FindName($_.Name)
    }

$Link1.Add_PreviewMouseDown({[system.Diagnostics.Process]::start('https://bonguides.com')})

# Download links
    $uri = "https://github.com/bonben365/office-installer/raw/main/setup.exe"
    $uri2013 = "https://github.com/bonben365/office-installer/raw/main/bin2013.exe"
    $uninstall = 'https://filedn.com/lOX1R8Sv7vhpEG9Q77kMbn0/MSGANG/scripts/office/uninstall.bat'
    $readme = 'https://filedn.com/lOX1R8Sv7vhpEG9Q77kMbn0/MSGANG/scripts/office/Readme.txt'

# Prepiaration for download and install
    function PreparingOffice {
        if ($radioButtonDownload.IsChecked) {
            $workingDir = New-Item -Path $env:userprofile\Desktop\$productId -ItemType Directory -Force
            Set-Location $workingDir
            Invoke-Item $workingDir
        }

        if ($radioButtonInstall.IsChecked) {
            $workingDir = New-Item -Path $env:temp\ClickToRun\$productId -ItemType Directory -Force
            Set-Location $workingDir
        }

        $configurationFile = "configuration-x$arch.xml"
        New-Item $configurationFile -ItemType File -Force | Out-Null
        Add-Content $configurationFile -Value "<Configuration>"
        Add-content $configurationFile -Value "<Add OfficeClientEdition=`"$arch`">"
        Add-content $configurationFile -Value "<Product ID=`"$productId`">"
        Add-content $configurationFile -Value "<Language ID=`"$languageId`"/>"
        Add-Content $configurationFile -Value "</Product>"
        Add-Content $configurationFile -Value "</Add>"
        Add-Content $configurationFile -Value "</Configuration>"

        $batchFile = "02.Install-x$arch.bat"
        New-Item $batchFile -ItemType File -Force | Out-Null
        Add-content $batchFile -Value "ClickToRun.exe /configure $configurationFile"

        (New-Object Net.WebClient).DownloadFile($uri, "$workingDir\ClickToRun.exe")
        (New-Object Net.WebClient).DownloadFile($readme, "$workingDir\01.Readme.txt")

        $sync.configurationFile = $configurationFile
        $sync.workingDir = $workingDir
    }
    
# Creating script block for download and install
    $DownloadInstallOffice = {
        function Write-HostDebug {
            #Helper function to write back to the host debug output
            param([Parameter(Mandatory)]
            [string]
            $debugMessage)
            if ($sync.DebugPreference) {
                $sync.host.UI.WriteDebugLine($debugMessage)
            }
        }

        function Write-VerboseDebug {
            param([Parameter(Mandatory)]
            [string]
            $verboseMessage)
            if ($sync.VerbosePreference) {
                $sync.host.UI.WriteVerboseLine($verboseMessage)
            }
        }

        Write-VerboseDebug "Downloading the $($sync.productName)"
        Write-VerboseDebug "Mode: $($sync.mode)"
        Write-VerboseDebug "Configuration file: $($sync.configurationFile)"

        # To referece our elements we use the $sync variable from hashtable.
        $sync.Form.Dispatcher.Invoke([action] { $sync.buttonSubmit.Visibility = "Hidden" })
        $sync.Form.Dispatcher.Invoke([action] { $sync.textbox.Text = "$($sync.UIstatus) $($sync.productName) $($sync.arch)-bit ($($sync.language))" })
        $sync.Form.Dispatcher.Invoke([action] { $sync.ProgressBar.BorderBrush = "#FF707070" })
        $sync.Form.Dispatcher.Invoke([action] { $sync.ProgressBar.IsIndeterminate = $true })
        $sync.Form.Dispatcher.Invoke([action] { $sync.image.Visibility = "Visible" })

        Set-Location -Path $($sync.workingDir)
        Write-VerboseDebug "Working (download) path: $pwd"
        Write-VerboseDebug "Command to run: .\ClickToRun.exe $($sync.mode) .\$($sync.configurationFile)"

        Start-Process -FilePath .\ClickToRun.exe -ArgumentList "$($sync.mode) .\$($sync.configurationFile)" -NoNewWindow -Wait
                
        # Bring back our Button, set the Label and ProgressBar, we're done..
        $sync.Form.Dispatcher.Invoke([action] { $sync.image.Visibility = "Hidden" })
        $sync.Form.Dispatcher.Invoke([action] { $sync.buttonSubmit.Visibility = 'Visible' })
        $sync.Form.Dispatcher.Invoke([action] { $sync.buttonSubmit.Content = 'Submit' })
        $sync.Form.Dispatcher.Invoke([action] { $sync.textbox.Text = 'Completed' })
        $sync.Form.Dispatcher.Invoke([action] { $sync.ProgressBar.IsIndeterminate = $false })
        $sync.Form.Dispatcher.Invoke([action] { $sync.ProgressBar.Value = '100' })

        Write-VerboseDebug "Done. You can close this window now."
    }

# Share info between runspaces
    $sync = [hashtable]::Synchronized(@{})
    $sync.runspace = $runspace
    $sync.host = $host
    $sync.Form = $Form
    $sync.ProgressBar = $ProgressBar
    $sync.textbox = $textbox
    $sync.image = $image
    $sync.buttonSubmit = $buttonSubmit
    $sync.DebugPreference = $DebugPreference
    $sync.VerbosePreference = $VerbosePreference

# Build a runspace
    $runspace = [runspacefactory]::CreateRunspace()
    $runspace.ApartmentState = 'STA'
    $runspace.ThreadOptions = 'ReuseThread'
    $runspace.Open()

# Add shared data to the runspace
    $runspace.SessionStateProxy.SetVariable("sync", $sync)

# Create a Powershell instance
    $PSIinstance = [powershell]::Create().AddScript($scriptBlock)
    $PSIinstance.Runspace = $runspace


# INSTALL/DOWNLOAD/ACTIVATE Microsoft Office with a runspace

    $buttonSubmit.Add_Click( {
            $i = 0
            if ($radioButtonArch32.IsChecked) {$arch = '32'}
            if ($radioButtonArch64.IsChecked) {$arch = '64'}

            if ($radioButtonVolume.IsChecked) {$licType = 'Volume'}
            if ($radioButtonRetail.IsChecked) {$licType = 'Retail'}

            if ($radioButtonEnglish.IsChecked) {$languageId="en-US"; $language = 'English'}
            if ($radioButtonJapanese.IsChecked) {$languageId="ja-JP"; $language = 'Japanese'}
            if ($radioButtonKorean.IsChecked) {$languageId="ko-KR"; $language = 'Korean'}
            if ($radioButtonChinese.IsChecked) {$languageId="zh-TW"; $language = 'Chinese'}
            if ($radioButtonFrench.IsChecked) {$languageId="fr-FR"; $language = 'French'}
            if ($radioButtonSpanish.IsChecked) {$languageId="es-ES"; $language = 'Spanish'}
            if ($radioButtonHindi.IsChecked) {$languageId="hi-IN"; $language = 'Hindi'}
            if ($radioButtonGerman.IsChecked) {$languageId="de-DE"; $language = 'German'}
            if ($radioButtonVietnamese.IsChecked) {$languageId="vi-VN"; $language = 'Vietnamese'}

            if ($radioButtonDownload.IsChecked) {$mode = '/download'; $UIstatus = 'Downlading'}
            if ($radioButtonInstall.IsChecked) {$mode = '/configure'; $UIstatus = 'Installing'}

            if ($radioButton365Home.IsChecked -eq $true) {$productId = "O365HomePremRetail"; $productName = 'Microsoft 365 Home'; $i++}
            if ($radioButton365Business.IsChecked -eq $true) {$productId = "O365BusinessRetail"; $productName = 'Microsoft 365 Apps for Business'; $i++}
            if ($radioButton365Enterprise.IsChecked -eq $true) {$productId = "O365ProPlusRetail"; $productName = 'Microsoft 365 Apps for Enterprise'; $i++}

        # For Office 2021
            if ($radioButton2021Pro.IsChecked -eq $true) {$productId = "ProPlus2021$licType"; $productName = 'Office 2021 Professional LTSC 2021'; $i++}
            if ($radioButton2021Std.IsChecked -eq $true) {$productId = "Standard2021$licType"; $productName = 'Office 2021 Standard LTSC'; $i++}
            if ($radioButton2021ProjectPro.IsChecked -eq $true) {$productId = "ProjectPro2021$licType"; $productName = 'Project Pro 2021'; $i++}
            if ($radioButton2021ProjectStd.IsChecked -eq $true) {$productId = "ProjectStd2021$licType"; $productName = 'Project Standard 2021'; $i++}
            if ($radioButton2021VisioPro.IsChecked -eq $true) {$productId = "VisioPro2021$licType"; $productName = 'Visio Pro 2021'; $i++}
            if ($radioButton2021VisioStd.IsChecked -eq $true) {$productId = "VisioStd2021$licType"; $productName = 'Visio Standard 2021'; $i++}
            if ($radioButton2021Word.IsChecked -eq $true) {$productId = "Word2021$licType"; $productName = 'Microsoft Word LTSC 2021'; $i++}
            if ($radioButton2021Excel.IsChecked -eq $true) {$productId = "Excel2021$licType"; $productName = 'Microsoft Excel LTSC 2021'; $i++}
            if ($radioButton2021PowerPoint.IsChecked -eq $true) {$productId = "PowerPoint2021$licType"; $productName = 'Microsoft PowerPoint LTSC 2021'; $i++}
            if ($radioButton2021Outlook.IsChecked -eq $true) {$productId = "Outlook2021$licType"; $productName = 'Microsoft Outlook LTSC 2021'; $i++}
            if ($radioButton2021Publisher.IsChecked -eq $true) {$productId = "Publisher2021$licType"; $productName = 'Microsoft Publisher LTSC 2021'; $i++}
            if ($radioButton2021Access.IsChecked -eq $true) {$productId = "Access2021$licType"; $productName = 'Microsoft Access LTSC 2021'; $i++}
            if ($radioButton2021HomeBusiness.IsChecked -eq $true) {$productId = "HomeBusiness2021Retail"; $productName = 'Office HomeBusiness 2021'; $i++}
            if ($radioButton2021HomeStudent.IsChecked -eq $true) {$productId = "HomeStudent2021Retail"; $productName = 'Office HomeStudent LTSC 2021'; $i++}

        # For Office 2019
            if ($radioButton2019Pro.IsChecked -eq $true) {$productId = "ProPlus2019$licType"; $productName = 'Office 2019 Professional Plus'; $i++}
            if ($radioButton2019Std.IsChecked -eq $true) {$productId = "Standard2019$licType"; $productName = 'Office 2019 Standard'; $i++}
            if ($radioButton2019ProjectPro.IsChecked -eq $true) {$productId = "ProjectPro2019$licType"; $productName = 'Project Pro 2019'; $i++}
            if ($radioButton2019ProjectStd.IsChecked -eq $true) {$productId = "ProjectStd2019$licType"; $productName = 'Project Standard 2019'; $i++}
            if ($radioButton2019VisioPro.IsChecked -eq $true) {$productId = "VisioPro2019$licType"; $productName = 'Visio Pro 2019'; $i++}
            if ($radioButton2019VisioStd.IsChecked -eq $true) {$productId = "VisioStd2019$licType"; $productName = 'Visio Standard 2019'; $i++}
            if ($radioButton2019Word.IsChecked -eq $true) {$productId = "Word2019$licType"; $productName = 'Microsoft Word 2019'; $i++}
            if ($radioButton2019Excel.IsChecked -eq $true) {$productId = "Excel2019$licType"; $productName = 'Microsoft Excel 2019'; $i++}
            if ($radioButton2019PowerPoint.IsChecked -eq $true) {$productId = "PowerPoint2019$licType"; $productName = 'Microsoft PowerPoint 201p'; $i++}
            if ($radioButton2019Outlook.IsChecked -eq $true) {$productId = "Outlook2019$licType"; $productName = 'Microsoft Outlook 2019'; $i++}
            if ($radioButton2019Publisher.IsChecked -eq $true) {$productId = "Publisher2019$licType"; $productName = 'Microsoft Publisher 2019'; $i++}
            if ($radioButton2019Access.IsChecked -eq $true) {$productId = "Access2019$licType"; $productName = 'Microsoft Access 2019'; $i++}
            if ($radioButton2019HomeBusiness.IsChecked -eq $true) {$productId = "HomeBusiness2019Retail"; $productName = 'Office HomeBusiness 2019'; $i++}
            if ($radioButton2019HomeStudent.IsChecked -eq $true) {$productId = "HomeStudent2019Retail"; $productName = 'Office HomeStudent 2019'; $i++}

        # For Office 2016
            if ($radioButton2016Pro.IsChecked -eq $true) {$productId = "ProfessionalRetail"; $productName = 'Office 2016 Professional Plus'; $i++}
            if ($radioButton2016Std.IsChecked -eq $true) {$productId = "StandardRetail"; $productName = 'Office 2016 Standard'; $i++}
            if ($radioButton2016ProjectPro.IsChecked -eq $true) {$productId = "ProjectProRetail"; $productName = 'Microsoft Project Pro 2016'; $i++}
            if ($radioButton2016ProjectStd.IsChecked -eq $true) {$productId = "ProjectStdRetail"; $productName = 'Microsoft Project Standard 2016'; $i++}
            if ($radioButton2016VisioPro.IsChecked -eq $true) {$productId = "VisioProRetail"; $productName = 'Microsoft Visio Pro 2016'; $i++}
            if ($radioButton2016VisioStd.IsChecked -eq $true) {$productId = "VisioStdRetail"; $productName = 'Microsoft Visio Standard 2016'; $i++}
            if ($radioButton2016Word.IsChecked -eq $true) {$productId = "WordRetail"; $productName = 'Microsoft Word 2016'; $i++}
            if ($radioButton2016Excel.IsChecked -eq $true) {$productId = "ExcelRetail"; $productName = 'Microsoft Excel 2016'; $i++}
            if ($radioButton2016PowerPoint.IsChecked -eq $true) {$productId = "PowerPointRetail"; $productName = 'Microsoft PowerPoint 2016'; $i++}
            if ($radioButton2016Outlook.IsChecked -eq $true) {$productId = "OutlookRetail"; $productName = 'Microsoft Outlook 2016'; $i++}
            if ($radioButton2016Publisher.IsChecked -eq $true) {$productId = "PublisherRetail"; $productName = 'Microsoft Publisher 2016'; $i++}
            if ($radioButton2016Access.IsChecked -eq $true) {$productId = "AccessRetail"; $productName = 'Microsoft Access 2016'; $i++}
            if ($radioButton2016OneNote.IsChecked -eq $true) {$productId = "OneNoteRetail"; $productName = 'Microsoft Onenote 2016'; $i++}

        # For Office 2013
            if ($radioButton2013Pro.IsChecked -eq $true) {$productId = "ProfessionalRetail"; $uri = $uri2013; $productName = 'Office 2013 Professional Plus'; $i++}
            if ($radioButton2013Std.IsChecked -eq $true) {$productId = "StandardRetail"; $uri = $uri2013; $productName = 'Office 2013 Standard'; $i++}
            if ($radioButton2013ProjectPro.IsChecked -eq $true) {$productId = "ProjectProRetail"; $uri = $uri2013; $productName = 'Microsoft Project Pro 2013'; $i++}
            if ($radioButton2013ProjectStd.IsChecked -eq $true) {$productId = "ProjectStdRetail"; $uri = $uri2013; $productName = 'Microsoft Project Standard 2013'; $i++}
            if ($radioButton2013VisioPro.IsChecked -eq $true) {$productId = "VisioProRetail"; $uri = $uri2013; $productName = 'Microsoft Visio Pro 2013'; $i++}
            if ($radioButton2013VisioStd.IsChecked -eq $true) {$productId = "VisioStdRetail"; $uri = $uri2013; $productName = 'Microsoft Visio Standard 2013'; $i++}
            if ($radioButton2013Word.IsChecked -eq $true) {$productId = "WordRetail"; $uri = $uri2013; $productName = 'Microsoft Word 2013'; $i++}
            if ($radioButton2013Excel.IsChecked -eq $true) {$productId = "ExcelRetail"; $uri = $uri2013; $productName = 'Microsoft Excel 2013'; $i++}
            if ($radioButton2013PowerPoint.IsChecked -eq $true) {$productId = "PowerPointRetail"; $uri = $uri2013; $productName = 'Microsoft PowerPoint 2013'; $i++}
            if ($radioButton2013Outlook.IsChecked -eq $true) {$productId = "OutlookRetail"; $uri = $uri2013; $productName = 'Microsoft Outlook 2013'; $i++}
            if ($radioButton2013Publisher.IsChecked -eq $true) {$productId = "PublisherRetail"; $uri = $uri2013; $productName = 'Microsoft Publisher 2013'; $i++}
            if ($radioButton2013Access.IsChecked -eq $true) {$productId = "AccessRetail"; $uri = $uri2013; $productName = 'Microsoft Access 2013'; $i++}
        # Update the shared hashtable
            $sync.arch = $arch
            $sync.mode = $mode
            $sync.language = $language
            $sync.UIstatus = $UIstatus
            $sync.productName = $productName

            if ($i -eq '1') {
                PreparingOffice
                $PSIinstance = [powershell]::Create().AddScript($DownloadInstallOffice)
                $PSIinstance.Runspace = $runspace
                $PSIinstance.BeginInvoke()
            } else {
                $sync.Form.Dispatcher.Invoke([action] { $sync.textbox.Foreground = "Red" })
                $sync.Form.Dispatcher.Invoke([action] { $sync.textbox.FontWeight = "Bold" })
                $sync.Form.Dispatcher.Invoke([action] { $sync.textbox.Text = "Please select an Office version." })
            }
    })

# Uninstall all installed Microsoft Office apps.
    $UninstallOffice = {

        $sync.Form.Dispatcher.Invoke([action] { $sync.textbox.Text = "Uninstalling Microsoft Office..." })
        $sync.Form.Dispatcher.Invoke([action] { $sync.buttonSubmit.Visibility = "Hidden" })
        $sync.Form.Dispatcher.Invoke([action] { $sync.ProgressBar.BorderBrush = "#FF707070" })
        $sync.Form.Dispatcher.Invoke([action] { $sync.ProgressBar.IsIndeterminate = $true })
        $sync.Form.Dispatcher.Invoke([action] { $sync.image.Visibility = "Visible" })
        
        Set-Location -Path $($sync.workingDir)
        (New-Object Net.WebClient).DownloadFile($($sync.uninstall), "$($sync.workingDir)\04.Uninstall.bat")
        Start-Process -FilePath .\04.Uninstall.bat -Wait
        
        $sync.Form.Dispatcher.Invoke([action] { $sync.image.Visibility = "Hidden" })
        $sync.Form.Dispatcher.Invoke([action] { $sync.buttonSubmit.Visibility = 'Visible' })
        $sync.Form.Dispatcher.Invoke([action] { $sync.buttonSubmit.Content = 'Submit' })
        $sync.Form.Dispatcher.Invoke([action] { $sync.textbox.Text = 'Completed' })
        $sync.Form.Dispatcher.Invoke([action] { $sync.ProgressBar.IsIndeterminate = $false })
        $sync.Form.Dispatcher.Invoke([action] { $sync.ProgressBar.Value = '100' })

        # Cleanup
        Set-Location ..
        Remove-Item ClickToRunU -Recurse -Force
    }

    $buttonRemoveAll.Add_Click({

        if ($radioButtonRemoveAllApp.IsChecked) {
            $workingDir = New-Item -Path $env:temp\ClickToRunU -ItemType Directory -Force
            Set-Location $workingDir
            $sync.workingDir = $workingDir
            $sync.uninstall = $uninstall

            $PSIinstance = [powershell]::Create().AddScript($UninstallOffice)
            $PSIinstance.Runspace = $runspace
            $PSIinstance.BeginInvoke()
        }
    })

$null = $Form.ShowDialog()