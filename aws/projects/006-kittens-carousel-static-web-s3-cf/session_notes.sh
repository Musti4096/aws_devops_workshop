Portfolio Building Session
Instructor - Serdar

29/10/2020

Project-104 : Kittens Carousel Static Website deploy on AWS Cloudfront, S3 and Route 53 using Cloudformation

Parameters

 - Domain Name ex. clarusway.us
 - Website Domain Name ex. kittens.clarusway.com

- S3
 - Bucket
 - Bucket Policy

- Cloudfront
 - Cloudfront Distribution

- Route 53
 - RecordSet for Website

- Certificate Manager
 - Certificate

https://aws.amazon.com/premiumsupport/knowledge-center/cloudfront-serve-static-website/


https://www.netsparker.com.tr/blog/web-guvenligi/chrome-68-ve-ssl-tls-implementasyonu-bilinmesi-gerekenler/

https://scotthelme.co.uk/certificate-transparency-an-introduction/


Sertifika Transparency, Sertifika Yetkilileri tarafından verilen sertifikaları neredeyse gerçek zamanlı olarak izlemek ve denetlemek için açık bir frameworkdur. Bir CA'nın ürettikleri tüm sertifikaları günlüğe kaydetmesini zorunlu kılarak, site sahipleri hatalı verilen sertifikaları hızlı bir şekilde belirleyebilir ve sahte bir CA'yı tespit etmek çok daha kolay hale gelir.

Eğer TLS/SSL gibi gönderilen paketin uçtan uca şifrelenerek aktarıldığı bir protokol kullanmıyorsanız, web sitesi erişimleriniz, bu istek paketinin hedefe varana kadar kat ettiği bütün yollarda okunabilir, değiştirilebilir. TLS/SSL protokolünün ilk amacı bunu engellemek. Tabii sadece bunu sağlamıyor. Aynı zamanda doğrulama ve yetkilendirme için de kullanılıyor.

SSL/TLS’in olmadığı bir web trafiğinde, web sitesi gezinimi için tarayıcınızdan çıkan paket ve bu pakete verilen cevap tüm aktarım noktalarında görülüp/değiştirilebileceği için, bu noktaları tutmak için hem yetki hem de teknik imkana sahip olanlar hangi web sitelerini, bu web sitelerindeki hangi kaynaklarına erişim talep ettiğinizi kolaylıkla görebilir; şayet yasal otoritenin bu kaynaklara erişime dair bir kararı varsa bunu kolaylıkla uygulayabilirler. Yani bir X sitede, Y haberini görmenize izin verilirken; Z haberini görmeniz engellenebilir; sayfa erişiminde yargı kararına dair bir not görebilirsiniz.

Fakat SSL/TLS kullanıldı ve doğru bir biçimde implemente edildi ise bu aktarım noktalarında paketinizin içeriği görülemeyeceği için; bir örnekle Wikipedia sitesine eriştiğinizi bilip, bu site üzerinde hangi maddelere erişmek istediğinizi kestiremeyecekleri için otoriteler bu sitelere erişimi bir bütün olarak engellemek zorunda kalacaklardır.

-----------

SSL/TLS, uçtan uca bir şifreleme sunarak, bütünlük, gizlilik ve yetkilendirme için elverişli bir yol sunar. İdeal bir SSL implementasyonunda, trafik boyunca transfer edilen verilerin, aktarım esnasında değişmediğinden, bir üçüncü kişi tarafından izlenemediğinden ve gerçekten de iletişim kurduğumuz kişinin bizim arzu ettiğimiz kişi olup olmadığından emin olabiliriz.

Özetle, ideal bir TLS/SSL implementasyonunda web trafiğiniz araya giren üçüncü herhangi bir kişi/kurum tarafından okunamaz, değiştirilemez.