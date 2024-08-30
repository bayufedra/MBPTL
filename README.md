# Most Basic Penetration Testing Lab (MBPTL)
Most Basic Penetration Testing Lab (MBPTL) is straight-forward hacking lab machine which designed for new comer who want to learn cyber security especially in Penetration Testing field. This is a self-deployed lab that runs inside Docker and is very easy to setup.

This lab is designed to be very straight-forward to introduce what steps can be taken during penetration testing and the tools related to these steps.

## What you will learn here
In this lab you will learn some basic penetration testing like:
- Reconnaissance
- Vulnerability Analysis
- Exploiting Vulnerable Apps
- Cracking Password
- Post Exploitation

## Set up Lab in Linux
#### Installing Docker
```
curl -s https://get.docker.com/ | sudo sh -
```

#### Installing GIT
```
sudo apt install git
```

#### Clone the Repository
```
git clone https://github.com/bayufedra/MBPTL
```

#### Deploy the Machine
```
cd MBPTL/mbptl/
sudo docker compose up -d
```

## What's the Next?
Remember that this lab is for the first step to learn Penetration Testing to give you an image about what we doing in penetration testing and after finish this lab, you can continue to learn with another lab like:

| Lab Name | Description |
|----------|-------------|
| [DVWA](https://github.com/digininja/DVWA) | Here you will learn more about basic application vulnerabilities. |
| [BWAPP](http://www.itsecgames.com/) | BWAPP (Bee-box Web Application Penetration Project) offers more vulnerabilities compared to DVWA, making it ideal for advanced learning. |
| [Hack The Box](https://www.hackthebox.com/) | A platform where you can practice on various machines remotely, without needing to set up a local environment. Access is provided through a VPN. |
| [Try Hack Me](https://tryhackme.com/) | Similar to Hack The Box, Try Hack Me offers a variety of learning paths and challenges, with guided labs and more accessible content for beginners. |
| [OWASP Juice Shop](https://owasp.org/www-project-juice-shop/) | A modern, intentionally vulnerable web application for security training. Juice Shop covers a wide range of vulnerabilities and is a great tool for learning about web security. |
| [WebGoat](https://owasp.org/www-project-webgoat/) | A deliberately insecure application created by OWASP, allowing developers to learn about security vulnerabilities in web applications. |
| [Metasploitable2](https://sourceforge.net/projects/metasploitable/) | An intentionally vulnerable Linux virtual machine, which is great for learning about network and system-level vulnerabilities. |
| [VulnHub](https://www.vulnhub.com/) | A collection of vulnerable virtual machines, designed for practicing penetration testing in a controlled environment. |
| [OverTheWire](https://overthewire.org/wargames/) | A series of wargames that help you learn and practice security concepts in a fun and challenging way. |

### Recommended Tools

While working with these labs, you might find the following tools helpful:

- **[Burp Suite](https://portswigger.net/burp)**: A comprehensive tool for web application security testing.
- **[Nmap](https://nmap.org/)**: A network scanning tool to discover hosts and services on a computer network.
- **[Metasploit](https://www.metasploit.com/)**: A framework for developing, testing, and executing exploits against a remote target machine.

## License

This repository is licensed under the GPL-3.0 license. See the [LICENSE](LICENSE) file for more information.

## Contact

For any inquiries or to connect with me, feel free to reach out on social media:

- **LinkedIn**: [Bayu Fedra](https://www.linkedin.com/in/bayufedra)
- **Instagram**: [@bayufedraa](https://www.instagram.com/bayufedraa)
- **Twitter/X**: [@bayufedraa](https://x.com/bayufedraa)

You can also [email me](mailto:bayufedra@gmail.com) for further questions.
