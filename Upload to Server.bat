cd WebRoot
jar cvf WebRoot.jar *
D:\putty\PSCP.EXE -sftp -l root -pw c13662860 WebRoot.jar chcbz.net:/home/webapp/hostroot/weixin.chcbz.net/
del WebRoot.jar