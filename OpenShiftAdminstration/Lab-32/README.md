# Kubernetes: Namespace, Resource Quota, and MySQL Deployment

## Overview
This guide outlines how to:
- Create a namespace in Kubernetes.
- Apply a resource quota to limit the number of pods in the namespace.
- Deploy a MySQL database with resource requests and limits.
- Configure the database using a ConfigMap and secure passwords using Secrets.
- Verify the deployment by connecting to the MySQL pod and checking database configurations.

---

## Steps

### **1. Create a Namespace**
Run the following command to create a namespace called `ivolve`:
```bash
kubectl create namespace ivolve
```

![image](https://github.com/user-attachments/assets/a24aa73a-1908-4f61-b454-4a87556bfbf1)

---

### **2. Apply Resource Quota**
Save the following YAML as `resource-quota.yaml`:
```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: pod-quota
  namespace: ivolve
spec:
  hard:
    pods: "2"
```
Apply the resource quota:
```bash
kubectl apply -f resource-quota.yaml
```

![image](https://github.com/user-attachments/assets/4c5d22b1-0038-438d-8e3c-01a4f463ea03)

---

### **3. Create a ConfigMap for MySQL**
Save the following YAML as `mysql-configmap.yaml`:
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: mysql-config
  namespace: ivolve
data:
  MYSQL_DATABASE: ivolve_db
  MYSQL_USER: ivolve_user
```
Apply the ConfigMap:
```bash
kubectl apply -f mysql-configmap.yaml
```

![image](https://github.com/user-attachments/assets/e5e990f4-d30a-44b5-b96f-860431273cbf)

---

### **4. Create a Secret for MySQL Passwords**
Save the following YAML as `mysql-secret.yaml`:
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: mysql-secret
  namespace: ivolve
type: Opaque
data:
  MYSQL_ROOT_PASSWORD: cGFzc3dvcmQ=  # Base64 encoded value for "password"
  MYSQL_PASSWORD: dXNlcl9wYXNz       # Base64 encoded value for "user_pass"
```
Encode your passwords to Base64:
```bash
echo -n "password" | base64
echo -n "user_pass" | base64
```
Apply the Secret:
```bash
kubectl apply -f mysql-secret.yaml
```

---

### **5. Deploy MySQL**
Save the following YAML as `mysql-deployment.yaml`:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mysql-deployment
  namespace: ivolve
spec:
  replicas: 3
  selector:
    matchLabels:
      app: mysql
  template:
    metadata:
      labels:
        app: mysql
    spec:
      containers:
      - name: mysql
        image: mysql:5.7
        ports:
        - containerPort: 3306
        envFrom:
        - configMapRef:
            name: mysql-config
        env:
        - name: MYSQL_ROOT_PASSWORD
          valueFrom:
            secretKeyRef:
              name: mysql-secret
              key: MYSQL_ROOT_PASSWORD
        - name: MYSQL_PASSWORD
          valueFrom:
            secretKeyRef:
              name: mysql-secret
              key: MYSQL_PASSWORD
        resources:
          requests:
            cpu: "500m"
            memory: "1Gi"
          limits:
            cpu: "1"
            memory: "2Gi"
```
Apply the deployment:
```bash
kubectl apply -f mysql-deployment.yaml
```

---

### **6. Verify Deployment**
Since the resource quota limits the namespace to 2 pods, the deployment will fail. Scale down the replicas:
```bash
kubectl scale deployment mysql-deployment --replicas=2 -n ivolve
```

Verify pods:
```bash
kubectl get pods -n ivolve
```
![image](https://github.com/user-attachments/assets/6626a1ba-1f3f-464a-b129-4dbb8690d58a)

---

### **7. Connect to the MySQL Pod**
Find a running MySQL pod:
```bash
kubectl get pods -n ivolve -l app=mysql
```

Exec into the pod:
```bash
kubectl exec -it <mysql-pod-name> -n ivolve -- bash
```

Log in to MySQL:
```bash
mysql -u root -p
# Enter the root password (e.g., "password" from the Secret)
```

Verify the database and user configurations:
```sql
SHOW DATABASES;
SELECT User FROM mysql.user;
```
![image](https://github.com/user-attachments/assets/81fc3992-b6bc-4289-b94e-14425b769845)

---

## Summary of YAML Files
1. **`resource-quota.yaml`**: Limits the namespace to 2 pods.
2. **`mysql-configmap.yaml`**: Configures the database name and user.
3. **`mysql-secret.yaml`**: Stores the passwords securely.
4. **`mysql-deployment.yaml`**: Creates the MySQL deployment.

---

