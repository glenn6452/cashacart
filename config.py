c = get_config()
c.ExecutePreprocessor.timeout = 300
c.NbConvertApp.export_format = 'mail'
c.Exporter.preprocessors = ['nbconvert.preprocessors.ExecutePreprocessor']
c.NbConvertApp.postprocessor_class = 'nb2mail.SendMailPostProcessor'
c.SendMailPostProcessor.recipient = 'glenn.dalida@oriente.com.ph'
c.SendMailPostProcessor.smtp_user = 'glenn.dalida@oriente.com.ph'
c.SendMailPostProcessor.smtp_pass = 'Zu@8uthe'
c.SendMailPostProcessor.smtp_addr = 'smtp.office365.com'
c.SendMailPostProcessor.smtp_port = 587
c.MailExporter.anchor_link_text = '' # disable pilcrow, requires nbconvert >= 5.2
c.CSSHTMLHeaderPreprocessor.enabled=True