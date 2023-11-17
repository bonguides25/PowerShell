<# Name       : Microsoft Office Download/Install for Free by Leo (Windows 7 Only)
Windows 10    : For Windows 10, the script can be found at https://bonguides.com/office
Description   : Download and Install all Offices Editions for free without any software.
Website       : https://bonguides.com
Script by     : Leo Nguyen #>

if (-not([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "You need to have Administrator rights to run this script!`nPlease re-run this script as an Administrator in an elevated powershell prompt!"
    break
  }
  
  # Create a WinForms
    Add-Type -AssemblyName System.Drawing, PresentationFramework, System.Windows.Forms, WindowsFormsIntegration, PresentationCore
    [System.Windows.Forms.Application]::EnableVisualStyles()
  
    $Form                       = New-Object System.Windows.Forms.Form    
    $Form.Size                  = New-Object System.Drawing.Size(660,500)
    $Form.StartPosition         = "CenterScreen"
    $Form.FormBorderStyle       = [System.Windows.Forms.FormBorderStyle]::FixedToolWindow 
    $Form.Text                  = "Microsoft Office Download Tool - www.bonguides.com"
    $Form.Font                  = New-Object System.Drawing.Font("Consolas",8,[System.Drawing.FontStyle]::Regular)
    $Form.ShowInTaskbar         = $True
    $Form.KeyPreview            = $True
    $Form.AutoSize              = $True
    $Form.BackColor             = "#1F1F1F"
    $Form.FormBorderStyle       = "Fixed3D"
  
    $Label                    = New-Object System.Windows.Forms.Label
    $Label.Font               = New-Object System.Drawing.Font("Consolas", 8, [System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
    $Label.ForeColor          = 'White'
    $Label.Size               = New-Object System.Drawing.Size(130,60)
    $label.TextAlign          = 'MiddleCenter'
    $Label.Location           = New-Object System.Drawing.Size(178,288)
    $Form.Controls.Add($Label)
  
    $ProgressBar              = New-Object System.Windows.Forms.ProgressBar
    $ProgressBar.Location     = New-Object System.Drawing.Size(177,280)
    $ProgressBar.Size         = New-Object System.Drawing.Size(124, 10)
    $ProgressBar.Style        = "Marquee"
    $ProgressBar.Hide()
    $ProgressBar.BringToFront()
    $ProgressBar.MarqueeAnimationSpeed = 10
    $Form.Controls.Add($ProgressBar)
  
    $pictureBox               = New-Object Windows.Forms.PictureBox
    $pictureBox.Location      = New-Object System.Drawing.Size(200,145)
    $pictureBox.Size          = New-Object System.Drawing.Size(70,70)
    $pictureBox.SizeMode      = 'StretchImage'
    $pictureBox.Visible       = $false
    $pictureBox.Load('https://filedn.com/lOX1R8Sv7vhpEG9Q77kMbn0/bg/img/form-img2.png')
    $form.Controls.Add($pictureBox)
  
    $pictureBox1               = New-Object Windows.Forms.PictureBox
    $pictureBox1.Location      = New-Object System.Drawing.Size(555,375)
    $pictureBox1.Size          = New-Object System.Drawing.Size(50,55)
    $pictureBox1.SizeMode      = 'StretchImage'
    $pictureBox1.Load('https://filedn.com/lOX1R8Sv7vhpEG9Q77kMbn0/bg/img/form-img1.png')
    $form.Controls.Add($pictureBox1)
  
  
    $uri = "https://filedn.com/lOX1R8Sv7vhpEG9Q77kMbn0/MSGANG/scripts/office/setup7.exe"
    $uri2013 = "https://filedn.com/lOX1R8Sv7vhpEG9Q77kMbn0/MSGANG/scripts/office/setup2013.exe"
    $activator = 'https://filedn.com/lOX1R8Sv7vhpEG9Q77kMbn0/MSGANG/scripts/office/activator7.bat'
    $readme = 'https://filedn.com/lOX1R8Sv7vhpEG9Q77kMbn0/MSGANG/scripts/office/Readme.txt'
    $link = 'https://filedn.com/lOX1R8Sv7vhpEG9Q77kMbn0/MSGANG/scripts/office/Microsoft%20products%20for%20FREE.html'
  
  # Declare InstallOffice function 
    function InstallOffice {
  
      $submitButton.Text    = "$status ..."
      $Label.Text           = "$status $productName!"
      $ProgressBar.Visible  = $true
      $pictureBox.Visible   = $true
  
      New-Item -Path $env:userprofile\Desktop\ClickToRun -ItemType Directory -Force | Set-Location
  
      New-Item productId.txt -ItemType File -Force | Out-Null
      Add-Content productId.txt -Value "$productId"
  
      New-Item mode.txt -ItemType File -Force | Out-Null
      Add-Content mode.txt -Value "$mode"
      
      New-Item arch.txt -ItemType File -Force | Out-Null
      Add-Content arch.txt -Value "$arch"
  
      New-Item uri.txt -ItemType File -Force | Out-Null
      Add-Content uri.txt -Value "$uri"
  
      New-Item activator.txt -ItemType File -Force | Out-Null
      Add-Content activator.txt -Value "$activator"
  
      New-Item link.txt -ItemType File -Force | Out-Null
      Add-Content link.txt -Value "$link"
  
      New-Item readme.txt -ItemType File -Force | Out-Null
      Add-Content readme.txt -Value "$readme"
  
      $workingDir = New-Item -Path $env:userprofile\Desktop\ClickToRun\$(Get-Content .\productId.txt) -ItemType Directory -Force
      Set-Location $workingDir
  
      if ($installModeDownload.Checked -eq $true) {
        Invoke-Item $workingDir
      }
      
      $configurationFile = "configuration-x$arch.xml"
      $batchFile = "02.Install-x$arch.bat"
     
      New-Item $batchFile -ItemType File -Force | Out-Null
      Add-content $batchFile -Value "ClickToRun.exe /configure $configurationFile"
      New-Item $configurationFile -ItemType File -Force | Out-Null
     
      Add-Content $configurationFile -Value "<Configuration>"
     
      if (($m365Home.Checked -eq $true) -or ($m365Business.Checked -eq $true) -or ($m365Enterprise.Checked -eq $true)){
        Add-content $configurationFile -Value "<Add OfficeClientEdition=`"$(Get-Content ..\arch.txt)`" Channel='SemiAnnualPreview' Version='16.0.12527.20880'>"
      } else {
        Add-content $configurationFile -Value "<Add OfficeClientEdition=`"$arch`">"
      }
  
      Add-content $configurationFile -Value "<Product ID=`"$(Get-Content ..\productId.txt)`">"
      Add-content $configurationFile -Value "$value3"
      Add-Content $configurationFile -Value "</Product>"
      Add-Content $configurationFile -Value "</Add>"
      Add-Content $configurationFile -Value "</Configuration>"
  
      $job1 = Start-Job -ScriptBlock {
  
        $productId  = Get-Content $env:userprofile\Desktop\ClickToRun\productId.txt
        $uri        = Get-Content $env:userprofile\Desktop\ClickToRun\uri.txt
        $activator  = Get-Content $env:userprofile\Desktop\ClickToRun\activator.txt
        $link       = Get-Content $env:userprofile\Desktop\ClickToRun\link.txt
        $readme     = Get-Content $env:userprofile\Desktop\ClickToRun\readme.txt
        
        $workingDir = "$env:userprofile\Desktop\ClickToRun\$productId"
        Set-Location -Path $workingDir
  
        (New-Object Net.WebClient).DownloadFile("$activator", "$workingDir\03.Activator.bat")
        (New-Object Net.WebClient).DownloadFile("$readme", "$workingDir\01.Readme.txt")
        (New-Object Net.WebClient).DownloadFile("$link", "$workingDir\Microsoft products for FREE.html")
        (New-Object Net.WebClient).DownloadFile("$uri", "$workingDir\ClickToRun.exe")
      }
      do { [System.Windows.Forms.Application]::DoEvents() } until ($job1.State -eq "Completed")
  
      $job = Start-Job -ScriptBlock {
  
        $productId = Get-Content $env:userprofile\Desktop\ClickToRun\productId.txt
        Set-Location -Path $env:userprofile\Desktop\ClickToRun\$productId
  
        $xml = (Get-ChildItem -Path "*.xml" -Recurse -Force).Name
        $mode = Get-Content ..\mode.txt
  
        Start-Process -FilePath .\ClickToRun.exe -ArgumentList "$mode .\$xml" -NoNewWindow -Wait
      }
  
      do { [System.Windows.Forms.Application]::DoEvents() } until ($job.State -eq "Completed")
  
      # Cleaning jobs
      Get-Job | Remove-Job -Force
  
      # Get back the Submit button, hide picturebox and progress bar.
      $submitButton.Text    = "Submit"
      $Label.Text           = "Completed!"
      $pictureBox.Visible   = $false
      $ProgressBar.Hide()
  
      # Cleaning up
      Remove-Item ..\mode.txt, ..\arch.txt, ..\productId.txt, ..\activator.txt, ..\uri.txt, ..\link.txt, ..\readme.txt
      Write-Host "Done. You can close the PowerShell window." 
    }
  
  # Declare the main function
    function mainFunction {
      try {
        if ($arch32.Checked -eq $true) {$arch="32"}
        if ($arch64.Checked -eq $true) {$arch="64"}
  
        if ($installModeSetup.Checked -eq $true) {$mode='/configure'; $status = "Installing"}
        if ($installModeDownload.Checked -eq $true) {$mode='/download'; $status = "Downoading"}
  
        if ($English.Checked -eq $true) {$languageId="en-US"; $value3 = "<Language ID=`"en-US`"/>"}
        if ($Japanese.Checked -eq $true) {$languageId="ja-JP"; $value3 = "<Language ID=`"ja-JP`"/>"}
        if ($Korean.Checked -eq $true) {$languageId="ko-KR"; $value3 = "<Language ID=`"ko-KR`"/>"}
        if ($Chinese.Checked -eq $true) {$languageId="zh-TW"; $value3 = "<Language ID=`"zh-TW`"/>"}
        if ($French.Checked -eq $true) {$languageId="fr-FR"; $value3 = "<Language ID=`"fr-FR`"/>"}
        if ($Spanish.Checked -eq $true) {$languageId="es-ES"; $value3 = "<Language ID=`"es-ES`"/>"}
        if ($Vietnamese.Checked -eq $true) {$languageId="vi-VN"; $value3 = "<Language ID=`"vi-VN`"/>"}
        if ($Portuguese.Checked -eq $true) {$languageId="pt-PT"; $value3 = "<Language ID=`"pt-PT`"/>"}
  
        if ($m365Home.Checked -eq $true) {$productId = "O365HomePremRetail"; $productName = 'Microsoft 365 Home'; InstallOffice}
        if ($m365Business.Checked -eq $true) {$productId = "O365BusinessRetail"; $productName = 'Microsoft 365 Apps for Business'; InstallOffice}
        if ($m365Enterprise.Checked -eq $true) {$productId = "O365ProPlusRetail"; $productName = 'Microsoft 365 Apps for Enterprise'; InstallOffice}
  
        if ($2016Pro.Checked -eq $true) {$productId = "ProfessionalRetail"; $productName = 'Office 2016 Professional Plus'; InstallOffice}
        if ($2016Std.Checked -eq $true) {$productId = "StandardRetail"; $productName = 'Office 2016 Standard'; InstallOffice}
        if ($2016ProjectPro.Checked -eq $true) {$productId = "ProjectProRetail"; $productName = 'Microsoft Project Pro 2016'; InstallOffice}
        if ($2016ProjectStd.Checked -eq $true) {$productId = "ProjectStdRetail"; $productName = 'Microsoft Project Standard 2016'; InstallOffice}
        if ($2016VisioPro.Checked -eq $true) {$productId = "VisioProRetail"; $productName = 'Microsoft Visio Pro 2016'; InstallOffice}
        if ($2016VisioStd.Checked -eq $true) {$productId = "VisioStdRetail"; $productName = 'Microsoft Visio Standard 2016'; InstallOffice}
        if ($2016Word.Checked -eq $true) {$productId = "WordRetail"; $productName = 'Microsoft Word 2016'; InstallOffice}
        if ($2016Excel.Checked -eq $true) {$productId = "ExcelRetail"; $productName = 'Microsoft Excel 2016'; InstallOffice}
        if ($2016PowerPoint.Checked -eq $true) {$productId = "PowerPointRetail"; $productName = 'Microsoft PowerPoint 2016'; InstallOffice}
        if ($2016Outlook.Checked -eq $true) {$productId = "OutlookRetail"; $productName = 'Microsoft Outlook 2016'; InstallOffice}
        if ($2016Publisher.Checked -eq $true) {$productId = "PublisherRetail"; $productName = 'Microsoft Publisher 2016'; InstallOffice}
        if ($2016Access.Checked -eq $true) {$productId = "AccessRetail"; $productName = 'Microsoft Access 2016'; InstallOffice}
        if ($2016OneNote.Checked -eq $true) {$productId = "OneNoteRetail"; $productName = 'Microsoft Onenote 2016'; InstallOffice}
  
        if ($2013Pro.Checked -eq $true) {$productId = "ProfessionalRetail"; $uri = $uri2013; $productName = 'Office 2013 Professional Plus'; InstallOffice}
        if ($2013Std.Checked -eq $true) {$productId = "StandardRetail"; $uri = $uri2013; $productName = 'Office 2013 Standard'; InstallOffice}
        if ($2013ProjectPro.Checked -eq $true) {$productId = "ProjectProRetail"; $uri = $uri2013; $productName = 'Microsoft Project Pro 2013'; InstallOffice}
        if ($2013ProjectStd.Checked -eq $true) {$productId = "ProjectStdRetail"; $uri = $uri2013; $productName = 'Microsoft Project Standard 2013'; InstallOffice}
        if ($2013VisioPro.Checked -eq $true) {$productId = "VisioProRetail"; $uri = $uri2013; $productName = 'Microsoft Visio Pro 2013'; InstallOffice}
        if ($2013VisioStd.Checked -eq $true) {$productId = "VisioStdRetail"; $uri = $uri2013; $productName = 'Microsoft Visio Standard 2013'; InstallOffice}
        if ($2013Word.Checked -eq $true) {$productId = "WordRetail"; $uri = $uri2013; $productName = 'Microsoft Word 2013'; InstallOffice}
        if ($2013Excel.Checked -eq $true) {$productId = "ExcelRetail"; $uri = $uri2013; $productName = 'Microsoft Excel 2013'; InstallOffice}
        if ($2013PowerPoint.Checked -eq $true) {$productId = "PowerPointRetail"; $uri = $uri2013; $productName = 'Microsoft PowerPoint 2013'; InstallOffice}
        if ($2013Outlook.Checked -eq $true) {$productId = "OutlookRetail"; $uri = $uri2013; $productName = 'Microsoft Outlook 2013'; InstallOffice}
        if ($2013Publisher.Checked -eq $true) {$productId = "PublisherRetail"; $uri = $uri2013; $productName = 'Microsoft Publisher 2013'; InstallOffice}
        if ($2013Access.Checked -eq $true) {$productId = "AccessRetail"; $uri = $uri2013; $productName = 'Microsoft Access 2013'; InstallOffice}
      }
      catch {}
    }
  
  # Start arch groupbox and checkboxes
    $arch                       = New-Object System.Windows.Forms.GroupBox
    $arch.Location              = New-Object System.Drawing.Size(10,10) 
    $arch.Size                  = New-Object System.Drawing.Size(130,74)
    $arch.Text                  = "Arch:"
    $arch.Font                  = New-Object System.Drawing.Font("Consolas",9,[System.Drawing.FontStyle]::Regular)
    $arch.ForeColor             = [System.Drawing.Color]::White
    $Form.Controls.Add($arch)
  
    $arch32                     = New-Object System.Windows.Forms.RadioButton
    $arch32.Location            = New-Object System.Drawing.Size(10,21)
    $arch32.Size                = New-Object System.Drawing.Size(110,20)
    $arch32.Checked             = $True
    $arch32.Text                = "32 bit"
    $arch.Controls.Add($arch32)
  
    $arch64                     = New-Object System.Windows.Forms.RadioButton
    $arch64.Location            = New-Object System.Drawing.Size(10,42)
    $arch64.Size                = New-Object System.Drawing.Size(110,20)
    $arch64.Checked             = $false
    $arch64.Text                = "64 bit"
    $arch.Controls.Add($arch64)
  
  # Start installMode groupbox and checkboxes
    $installMode                = New-Object System.Windows.Forms.GroupBox
    $installMode.Location       = New-Object System.Drawing.Size(10,90) 
    $installMode.Size           = New-Object System.Drawing.Size(130,75) 
    $installMode.Text           = "Mode:"
    $installMode.Font           = New-Object System.Drawing.Font("Consolas",9,[System.Drawing.FontStyle]::Regular)
    $installMode.ForeColor      = [System.Drawing.Color]::White
    $Form.Controls.Add($installMode)
  
    $installModeSetup           = New-Object System.Windows.Forms.RadioButton
    $installModeSetup.Location  = New-Object System.Drawing.Size(10,21)
    $installModeSetup.Size      = New-Object System.Drawing.Size(110,20)
    $installModeSetup.Checked   = $True
    $installModeSetup.Text      = "Install"
    $installMode.Controls.Add($installModeSetup)
  
    $installModeDownload          = New-Object System.Windows.Forms.RadioButton
    $installModeDownload.Location = New-Object System.Drawing.Size(10,42)
    $installModeDownload.Size     = New-Object System.Drawing.Size(110,20)
    $installModeDownload.Checked  = $false
    $installModeDownload.Text     = "Download"
    $installMode.Controls.Add($installModeDownload)
  
  # Start language groupbox and checkboxes
    $language                   = New-Object System.Windows.Forms.GroupBox
    $language.Location          = New-Object System.Drawing.Size(10,172) 
    $language.Size              = New-Object System.Drawing.Size(130,183)
    $language.Text              = "Language:"
    $language.ForeColor         = [System.Drawing.Color]::White
    $language.Font              = New-Object System.Drawing.Font("Consolas",9,[System.Drawing.FontStyle]::Regular)
    $Form.Controls.Add($language) 
  
    $English                    = New-Object System.Windows.Forms.RadioButton
    $English.Location           = New-Object System.Drawing.Size(10,21)
    $English.Size               = New-Object System.Drawing.Size(110,20)
    $English.Checked            = $true
    $English.Text               = "English"
    $language.Controls.Add($English)
  
    $Japanese                   = New-Object System.Windows.Forms.RadioButton
    $Japanese.Location          = New-Object System.Drawing.Size(10,42)
    $Japanese.Size              = New-Object System.Drawing.Size(110,20)
    $Japanese.Text              = "Japanese"
    $language.Controls.Add($Japanese)
  
    $Korean                     = New-Object System.Windows.Forms.RadioButton
    $Korean.Location            = New-Object System.Drawing.Size(10,63)
    $Korean.Size                = New-Object System.Drawing.Size(110,20)
    $Korean.Text                = "Korean"
    $language.Controls.Add($Korean)
  
    $French                     = New-Object System.Windows.Forms.RadioButton
    $French.Location            = New-Object System.Drawing.Size(10,84)
    $French.Size                = New-Object System.Drawing.Size(110,20)
    $French.Text                = "French"
    $language.Controls.Add($French)
  
    $Spanish                    = New-Object System.Windows.Forms.RadioButton
    $Spanish.Location           = New-Object System.Drawing.Size(10,105)
    $Spanish.Size               = New-Object System.Drawing.Size(110,20)
    $Spanish.Text               = "Spanish"
    $language.Controls.Add($Spanish)
  
    $Portuguese                 = New-Object System.Windows.Forms.RadioButton
    $Portuguese.Location        = New-Object System.Drawing.Size(10,126)
    $Portuguese.Size            = New-Object System.Drawing.Size(110,20)
    $Portuguese.Text            = "Portuguese"
    $language.Controls.Add($Portuguese)
  
    $Vietnamese                 = New-Object System.Windows.Forms.RadioButton
    $Vietnamese.Location        = New-Object System.Drawing.Size(10,147)
    $Vietnamese.Size            = New-Object System.Drawing.Size(110,20)
    $Vietnamese.Text            = "Vietnamese"
    $language.Controls.Add($Vietnamese)
  
  # Start Microsoft Office groupbox
    $groupboxOffice             = New-Object System.Windows.Forms.GroupBox
    $groupboxOffice.Location    = New-Object System.Drawing.Size(155,10) 
    $groupboxOffice.Size        = New-Object System.Drawing.Size(470,345) 
    $groupboxOffice.Text        = "Select an Office product to install:"
    $groupboxOffice.Font        = New-Object System.Drawing.Font("Consolas",9,[System.Drawing.FontStyle]::Regular)
    $groupboxOffice.ForeColor   = [System.Drawing.Color]::White
  
  # Office 365 checkboxes
    $label365                   = New-Object System.Windows.Forms.Label
    $label365.Location          = New-Object System.Drawing.Size(173,40)
    $label365.Text              = " Microsoft 365"
    $label365.Size              = New-Object System.Drawing.Size(130,22)
    $label365.BackColor         = 'Red'
    $label365.Font              = New-Object System.Drawing.Font("Consolas",9,[System.Drawing.FontStyle]::Bold)
    $label365.ForeColor         = 'White'
    $label365.TextAlign         = 'MiddleLeft'
    $Form.Controls.Add($label365)
  
    $m365Home                   = New-Object System.Windows.Forms.RadioButton
    $m365Home.Location          = New-Object System.Drawing.Size(20,62)
    $m365Home.Size              = New-Object System.Drawing.Size(100,20)
    $m365Home.Checked           = $false
    $m365Home.Text              = "Home"
    $groupboxOffice.Controls.Add($m365Home)
  
    $m365Business               = New-Object System.Windows.Forms.RadioButton
    $m365Business.Location      = New-Object System.Drawing.Size(20,83)
    $m365Business.Size          = New-Object System.Drawing.Size(100,20)
    $m365Business.Text          = "Business"
    $groupboxOffice.Controls.Add($m365Business)
  
    $m365Enterprise             = New-Object System.Windows.Forms.RadioButton
    $m365Enterprise.Location    = New-Object System.Drawing.Size(20,104)
    $m365Enterprise.Size        = New-Object System.Drawing.Size(100,20)
    $m365Enterprise.Text        = "Enterprise"
    $groupboxOffice.Controls.Add($m365Enterprise)
  
  # Office 2016 checkboxes
  
    $label2016                  = New-Object System.Windows.Forms.Label
    $label2016.Location         = New-Object System.Drawing.Size(320,40)
    $label2016.Text             = " Office 2016"
    $label2016.Size             = New-Object System.Drawing.Size(130,22)
    $label2016.BackColor        = 'Green'
    $label2016.Font             = New-Object System.Drawing.Font("Consolas",9,[System.Drawing.FontStyle]::Bold)
    $label2016.ForeColor        = 'White'
    $label2016.TextAlign        = 'MiddleLeft'
    $Form.Controls.Add($label2016)
  
    $2016Pro                    = New-Object System.Windows.Forms.RadioButton
    $2016Pro.Location           = New-Object System.Drawing.Size(170,62)
    $2016Pro.Size               = New-Object System.Drawing.Size(130,20)
    $2016Pro.Checked            = $false
    $2016Pro.Text               = "Professional"
    $2016Pro.BringToFront();
    $groupboxOffice.Controls.Add($2016Pro)
  
    $2016Std                    = New-Object System.Windows.Forms.RadioButton
    $2016Std.Location           = New-Object System.Drawing.Size(170,83)
    $2016Std.Size               = New-Object System.Drawing.Size(130,20)
    $2016Std.Text               = "Standard"
    $groupboxOffice.Controls.Add($2016Std)
  
    $2016ProjectPro             = New-Object System.Windows.Forms.RadioButton
    $2016ProjectPro.Location    = New-Object System.Drawing.Size(170,104)
    $2016ProjectPro.Size        = New-Object System.Drawing.Size(130,20)
    $2016ProjectPro.Text        = "Project Pro"
    $groupboxOffice.Controls.Add($2016ProjectPro)
  
    $2016ProjectStd             = New-Object System.Windows.Forms.RadioButton
    $2016ProjectStd.Location    = New-Object System.Drawing.Size(170,125)
    $2016ProjectStd.Size        = New-Object System.Drawing.Size(110,20)
    $2016ProjectStd.Text        = "Project Standard"
    $2016ProjectStd.AutoSize    = $true
    $groupboxOffice.Controls.Add($2016ProjectStd)
  
    $2016VisioPro               = New-Object System.Windows.Forms.RadioButton
    $2016VisioPro.Location      = New-Object System.Drawing.Size(170,146)
    $2016VisioPro.Size          = New-Object System.Drawing.Size(110,20)
    $2016VisioPro.Text          = "Visio Pro"
    $groupboxOffice.Controls.Add($2016VisioPro)
  
    $2016VisioStd               = New-Object System.Windows.Forms.RadioButton
    $2016VisioStd.Location      = New-Object System.Drawing.Size(170,167)
    $2016VisioStd.Size          = New-Object System.Drawing.Size(130,20)
    $2016VisioStd.Text          = "Visio Standard"
    $groupboxOffice.Controls.Add($2016VisioStd)
  
    $2016Word                   = New-Object System.Windows.Forms.RadioButton
    $2016Word.Location          = New-Object System.Drawing.Size(170,188)
    $2016Word.Size              = New-Object System.Drawing.Size(110,20)
    $2016Word.Text              = "Word"
    $groupboxOffice.Controls.Add($2016Word)
  
    $2016Excel                  = New-Object System.Windows.Forms.RadioButton
    $2016Excel.Location         = New-Object System.Drawing.Size(170,209)
    $2016Excel.Size             = New-Object System.Drawing.Size(110,20)
    $2016Excel.Text             = "Excel"
    $groupboxOffice.Controls.Add($2016Excel)
  
    $2016PowerPoint             = New-Object System.Windows.Forms.RadioButton
    $2016PowerPoint.Location    = New-Object System.Drawing.Size(170,230)
    $2016PowerPoint.Size        = New-Object System.Drawing.Size(110,20)
    $2016PowerPoint.Text        = "PowerPoint"
    $groupboxOffice.Controls.Add($2016PowerPoint)
  
    $2016Outlook                = New-Object System.Windows.Forms.RadioButton
    $2016Outlook.Location       = New-Object System.Drawing.Size(170,251)
    $2016Outlook.Size           = New-Object System.Drawing.Size(110,20)
    $2016Outlook.Text           = "Outlook"
    $groupboxOffice.Controls.Add($2016Outlook)
  
    $2016Publisher              = New-Object System.Windows.Forms.RadioButton
    $2016Publisher.Location     = New-Object System.Drawing.Size(170,272)
    $2016Publisher.Size         = New-Object System.Drawing.Size(110,20)
    $2016Publisher.Text         = "Publisher"
    $groupboxOffice.Controls.Add($2016Publisher)
  
    $2016Access                 = New-Object System.Windows.Forms.RadioButton
    $2016Access.Location        = New-Object System.Drawing.Size(170,293)
    $2016Access.Size            = New-Object System.Drawing.Size(110,20)
    $2016Access.Text            = "Access"
    $groupboxOffice.Controls.Add($2016Access)
  
    $2016OneNote                = New-Object System.Windows.Forms.RadioButton
    $2016OneNote.Location       = New-Object System.Drawing.Size(170,314)
    $2016OneNote.Size           = New-Object System.Drawing.Size(110,20)
    $2016OneNote.Text           = "OneNote"
    $groupboxOffice.Controls.Add($2016OneNote)
  
  # Office 2013 checkboxes 
  
    $label2013                  = New-Object System.Windows.Forms.Label
    $label2013.Location         = New-Object System.Drawing.Size(470,40)
    $label2013.Text             = " Office 2013"
    $label2013.Size             = New-Object System.Drawing.Size(130,22)
    $label2013.BackColor        = 'Blue'
    $label2013.Font             = New-Object System.Drawing.Font("Consolas",9,[System.Drawing.FontStyle]::Bold)
    $label2013.ForeColor        = 'White'
    $label2013.TextAlign        = 'MiddleLeft'
    $Form.Controls.Add($label2013)
  
    $2013Pro                    = New-Object System.Windows.Forms.RadioButton
    $2013Pro.Location           = New-Object System.Drawing.Size(318,62)
    $2013Pro.Size               = New-Object System.Drawing.Size(110,20)
    $2013Pro.Checked            = $false
    $2013Pro.Text               = "Professional"
    $groupboxOffice.Controls.Add($2013Pro)
  
    $2013Std                    = New-Object System.Windows.Forms.RadioButton
    $2013Std.Location           = New-Object System.Drawing.Size(318,83)
    $2013Std.Size               = New-Object System.Drawing.Size(110,20)
    $2013Std.Text               = "Standard"
    $groupboxOffice.Controls.Add($2013Std)
  
    $2013ProjectPro             = New-Object System.Windows.Forms.RadioButton
    $2013ProjectPro.Location    = New-Object System.Drawing.Size(318,104)
    $2013ProjectPro.Size        = New-Object System.Drawing.Size(110,20)
    $2013ProjectPro.Text        = "Project Pro"
    $groupboxOffice.Controls.Add($2013ProjectPro)
  
    $2013ProjectStd             = New-Object System.Windows.Forms.RadioButton
    $2013ProjectStd.Location    = New-Object System.Drawing.Size(318,125)
    $2013ProjectStd.Size        = New-Object System.Drawing.Size(110,20)
    $2013ProjectStd.Text        = "Project Standard"
    $2013ProjectStd.AutoSize    = $true
    $groupboxOffice.Controls.Add($2013ProjectStd)
  
    $2013VisioPro               = New-Object System.Windows.Forms.RadioButton
    $2013VisioPro.Location      = New-Object System.Drawing.Size(318,146)
    $2013VisioPro.Size          = New-Object System.Drawing.Size(110,20)
    $2013VisioPro.Text          = "Visio Pro"
    $groupboxOffice.Controls.Add($2013VisioPro)
  
    $2013VisioStd               = New-Object System.Windows.Forms.RadioButton
    $2013VisioStd.Location      = New-Object System.Drawing.Size(318,167)
    $2013VisioStd.Size          = New-Object System.Drawing.Size(110,20)
    $2013VisioStd.Text          = "Visio Standard"
    $groupboxOffice.Controls.Add($2013VisioStd)
  
    $2013Word                   = New-Object System.Windows.Forms.RadioButton
    $2013Word.Location          = New-Object System.Drawing.Size(318,188)
    $2013Word.Size              = New-Object System.Drawing.Size(110,20)
    $2013Word.Text              = "Word"
    $groupboxOffice.Controls.Add($2013Word)
  
    $2013Excel                  = New-Object System.Windows.Forms.RadioButton
    $2013Excel.Location         = New-Object System.Drawing.Size(318,209)
    $2013Excel.Size             = New-Object System.Drawing.Size(110,20)
    $2013Excel.Text             = "Excel"
    $groupboxOffice.Controls.Add($2013Excel)
  
    $2013PowerPoint             = New-Object System.Windows.Forms.RadioButton
    $2013PowerPoint.Location    = New-Object System.Drawing.Size(318,230)
    $2013PowerPoint.Size        = New-Object System.Drawing.Size(110,20)
    $2013PowerPoint.Text        = "PowerPoint"
    $groupboxOffice.Controls.Add($2013PowerPoint)
  
    $2013Outlook                = New-Object System.Windows.Forms.RadioButton
    $2013Outlook.Location       = New-Object System.Drawing.Size(318,251)
    $2013Outlook.Size           = New-Object System.Drawing.Size(110,20)
    $2013Outlook.Text           = "Outlook"
    $groupboxOffice.Controls.Add($2013Outlook)
  
    $2013Publisher              = New-Object System.Windows.Forms.RadioButton
    $2013Publisher.Location     = New-Object System.Drawing.Size(318,272)
    $2013Publisher.Size         = New-Object System.Drawing.Size(110,20)
    $2013Publisher.Text         = "Publisher"
    $groupboxOffice.Controls.Add($2013Publisher)
  
    $2013Access                 = New-Object System.Windows.Forms.RadioButton
    $2013Access.Location        = New-Object System.Drawing.Size(318,293)
    $2013Access.Size            = New-Object System.Drawing.Size(110,20)
    $2013Access.Text            = "Access"
    $groupboxOffice.Controls.Add($2013Access)
  
  
  # Start Submit button (event handeler)
    $submitButton               = New-Object System.Windows.Forms.Button 
    $submitButton.Cursor        = [System.Windows.Forms.Cursors]::Hand
    $submitButton.Location      = New-Object System.Drawing.Size(173,230) 
    $submitButton.Size          = New-Object System.Drawing.Size(130,40) 
    $submitButton.Text          = "Submit"
    $submitButton.BackColor     = [System.Drawing.Color]::Green
    $submitButton.ForeColor     = [System.Drawing.Color]::White
    $submitButton.Font          = New-Object System.Drawing.Font("Consolas",9,[System.Drawing.FontStyle]::Bold)
    $submitButton.Add_Click({mainFunction})
    $Form.Controls.Add($submitButton)
  
  # About lables and link(Descriptions)
  
    $aboutLabel1                    = New-Object System.Windows.Forms.Label
    $aboutLabel1.Location           = New-Object System.Drawing.Size(10,370)
    $aboutLabel1.AutoSize           = $True
    $aboutLabel1.ForeColor          = 'White'
    $aboutLabel1.Text               = "(*) By default, this script downloads Office 32-bit English."
  
    $aboutLabel2                    = New-Object System.Windows.Forms.Label
    $aboutLabel2.Location           = New-Object System.Drawing.Size(10,390)
    $aboutLabel2.AutoSize           = $True
    $aboutLabel2.ForeColor          = 'White' 
    $aboutLabel2.Text               = "(*) The downloaded files would be saved on the current user's desktop."
  
    $aboutLabel3                    = New-Object System.Windows.Forms.Label
    $aboutLabel3.Location           = New-Object System.Drawing.Size(10,410)
    $aboutLabel3.AutoSize           = $True
    $aboutLabel3.ForeColor          = 'White'
    $aboutLabel3.Text               = "(*) If you want to install Office in another language, select from Languages list."
  
    $linklabel                      = New-Object System.Windows.Forms.LinkLabel
    $linklabel.Text                 = "(*) For more: https://bonguides.com - Learning and Sharing."
    $linklabel.Location             = New-Object System.Drawing.Size(10,430) 
    $linklabel.AutoSize             = $True
    $linklabel.ForeColor            = 'White'
  
    #Sample hyperlinks to add to the text of the link label control.
      $URLInfo = [pscustomobject]@{
      StartPos = 14;
      LinkLength = 21;
      Url = 'http://bonguides.com'
    }
    #Add them.
    foreach ($URL in $URLinfo) {
      $null = $linklabel.Links.Add($URL.StartPos, $URL.LinkLength, $URL.URL)
    }
    #Register a handler for when the user clicks a link.
    $linklabel.add_LinkClicked({
      param($evtSender, $evtArgs)
      #Launch the default browser with the target URL.
      Start-Process $evtArgs.Link.LinkData
    })
  
    $form.Controls.AddRange(@($groupboxOffice,$linklabel,$aboutLabel1,$aboutLabel2,$aboutLabel3))
  
  # Show the form
    [void] $Form.ShowDialog()