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
#### Install Docker
```
curl -s https://get.docker.com/ | sudo sh -
```

#### Install GIT
```
sudo apt install git
```

#### Close Repository
```
git clone https://github.com/bayufedra/MBPTL
```

#### Deploy
```
cd MBPTL
sudo docker compose up -d
```
