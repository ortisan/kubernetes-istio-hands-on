# Kubernetes e Istio Hands On

Kubernetes (K8s) é um produto Open Source utilizado para automatizar a implantação, o dimensionamento e o gerenciamento de aplicativos em contêiner
-- <cite>https://kubernetes.io</cite>

## Preparação do ambiente

- Instalar o kubectl

  - [linux](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)

  - [windows](https://kubernetes.io/docs/tasks/tools/install-kubectl-windows/)

- Instalar [k3d](https://k3d.io/)

* Criar o cluster

```sh
k3d cluster create k8s-istio-handson --servers 1 --agents 3 --port 9080:80@loadbalancer --port 9443:443@loadbalancer --api-port 6443 --k3s-server-arg '--no-deploy=traefik'
```

Configurar o kubectl para o cluster k3d:

```sh
k3d kubeconfig merge k8s-istio-handson --kubeconfig-switch-context
```

## Kubernetes

### Client

_kubectl_ é o client oficial do K8s, e utilizamos ele para interagir com os objetos, como pods, services e deployments.

#### Cluster status

```sh
kubectl get componentstatuses
```

![image](images/statuses.png)
-- from <cite>author</cite>

### [Componentes do Cluster](https://kubernetes.io/pt-br/docs/concepts/overview/components/)

![image](images/components-of-kubernetes.svg)
-- from <cite>https://kubernetes.io/pt-br/docs/concepts/overview/components/</cite>

Um cluster Kubernetes consiste em um conjunto de servidores de processamento, chamados nós, que executam aplicações containerizadas. Todo cluster possui ao menos um servidor de processamento (worker node).

O servidor de processamento hospeda os Pods que são componentes de uma aplicação. O ambiente de gerenciamento gerencia os nós de processamento e os Pods no cluster. Em ambientes de produção, o ambiente de gerenciamento geralmente executa em múltiplos computadores e um cluster geralmente executa em múltiplos nós (nodes), provendo tolerância a falhas e alta disponibilidade.

-- from <cite>https://kubernetes.io/pt-br/docs/concepts/overview/components/</cite>

#### Control Plane

Os componentes do control plane são responsáveis em manter a saúde do cluster.

- _controler-manager_: Responsável regular os componentes do cluster. Ex: Assegura que todas as réplicas de um serviço estão disponíveis e saudáveis.

- _scheduler_: Responsável em escalonar os diferentes pods em diferentes nós.

- _etcd_: banco de dados chave valor do cluster.

#### Nodes

Podemos pensar em node como uma máquina física ou virtual que irá rodar um conjunto de containers. Cada node possui alguns componentes pré instalados responsáveis por comunicação com outros nodes e com o Control Plane.

- _kubelet_: Agente que controla e garante a disponibilidade dos pods.

- _kubernetes-proxy_: Componente responsável em rotear o tráfego de rede para os serviços de load balancer no cluster.

- _container-runtime_: agente responsável por executar os containers

```sh
kubectl get nodes
```

![image](images/get_nodes.png)
-- from <cite>author</cite>

#### Addons

Componentes que complementam as funcionalidades do Cluster.

- _kubernetes-dns_: Roda um DNS server e provê um serviço de nome e descoberta ao cluster.

```sh
kubectl get services --namespace=kube-system
```

![image](images/get_services_kube_system.png)
-- from <cite>author</cite>

### Namespaces

O Kubernetes usa os namespaces para organizar os objetos no cluster. Uma analogia é pensar em namespaces como pastas, onde cada pasta tenha seus respectivos objetos. Conforme imagem anterior, o Kubernetes tem seu próprio namespace chamado _kube-system_, e por default trabalhamos com o namespace _default_ para nossas aplicações.

```sh
kubectl get pods --all-namespaces
```

### Objetos

Os tipos de objetos são utilizados para diversas finalidades. As principais são:

- Pod - Menor unidade de deploy. Pode conter um ou mais containers. A configuração se faz através de um arquivo yaml chamado pod manifest.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-demo
spec:
  containers:
    - name: nginx
      image: nginx:1.7.9
      ports:
        - containerPort: 80
```

Criação do pod:

```sh
kubectl apply -f k8s/nginx-pod.yaml
```

Listagem:

```sh
kubectl get pods --output=wide
```

![image](images/get_pods.png)
-- from <cite>author</cite>

Detalhes:

```sh
kubectl describe pods nginx-demo
```

![image](images/describe_pods.png)
-- from <cite>author</cite>

- Service: Os objetos serviços dão aos pods ou deployments, a capacidade de receber um dns e também terem o service-discovery automático.

Exposição para o mundo externo:

```sh
# List services
kubectl get services
# Expose pod
kubectl expose pod nginx-demo --port 80 --type=LoadBalancer
# List services again
kubectl get services
```

![image](images/expose-service.png)
-- from <cite>author</cite>

![image](images/nginx_browser.png)
-- from <cite>author</cite>
