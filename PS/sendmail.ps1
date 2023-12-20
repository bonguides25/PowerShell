irm https://raw.githubusercontent.com/bonguides25/PowerShell/main/PS/cdx-report.ps1 | iex

function SendMailX {
        $secret = Get-Content -Path 'C:\temp\secret.txt'
        $computer = (Get-ComputerInfo).CsName
        $date = Get-Date -Format "dd/MM/yyyy"
        $serviceNamecdx = (Get-Service -Name *cdx*).Name
        $serviceStatuscdx = (Get-Service -Name *cdx*).Status

        $serviceNameoto = (Get-Service -Name *oto*).Name
        $serviceStatusoto = (Get-Service -Name *oto*).Status

        $EmailFrom = "noreply@msgang.com"
        $EmailTo = "noreply@msgang.com"
        $Subject = "[TSG]-[$($date)]-[PROVISIONING]-[$($computer)]"

        $Password = Get-Content -Path 'C:\temp\secret.txt' | ConvertTo-SecureString -AsPlainText -Force
        $Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $EmailFrom, $Password

        $Body = Invoke-RestMethod -Method GET -Uri "https://raw.githubusercontent.com/bonguides25/PowerShell/main/PS/email.html"
        # $Body = Get-Content -Path 'C:\Users\admin\email.html' -Raw

        #Replace the Variables
        $Body= $Body.Replace("serviceNamecdx",$serviceNamecdx)
        $Body= $Body.Replace("serviceStatuscdx",$serviceStatuscdx)

        $Body= $Body.Replace("serviceNameoto",$serviceNameoto)
        $Body= $Body.Replace("serviceStatusoto",$serviceStatusoto)

        $SMTPServer = "smtp.office365.com"

        #Send E-mail from PowerShell script
        Send-MailMessage `
        -To $EmailTo `
        -From $EmailFrom `
        -Subject $Subject `
        -Body $Body `
        -BodyAsHtml `
        -SmtpServer $SmtpServer `
        -UseSsl `
        -Port 587 `
        -Credential $Credential
    }

    SendMailX
