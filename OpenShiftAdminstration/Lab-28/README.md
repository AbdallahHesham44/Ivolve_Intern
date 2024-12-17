# Solving the MySQL StatefulSet Task

This README provides instructions and explanations for completing the following tasks:

1. **Comparison between Deployment and StatefulSet**
2. **Create a YAML file for a MySQL StatefulSet configuration**
3. **Write a YAML file to define a service for the MySQL StatefulSet**

## 1. Comparison Between Deployment and StatefulSet

| Feature                | Deployment                            | StatefulSet                                   |
|------------------------|---------------------------------------|----------------------------------------------|
| **Purpose**            | Used for stateless applications      | Used for stateful applications               |
| **Pod Identity**       | Pods are interchangeable, no unique identity | Each pod has a unique, stable identity        |
| **Scaling**            | Can scale up or down easily          | Maintains order and stability during scaling |
| **Storage**            | Ephemeral storage, no persistence    | Persistent storage with stable claims        |
| **Pod Management**     | Recreates pods without specific order | Creates and deletes pods in a defined order |
| **Use Case**           | Web servers, APIs, etc.              | Databases, caches, and stateful services     |

## 2. MySQL StatefulSet YAML Configuration

### StatefulSet YAML
```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: mysql
  labels:
    app: mysql
spec:
  serviceName: "mysql-service"
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
        image: mysql:8.0
        ports:
        - containerPort: 3306
          name: mysql
        env:
        - name: MYSQL_ROOT_PASSWORD
          value: "rootpassword" # Replace with a secure password
        volumeMounts:
        - name: mysql-persistent-storage
          mountPath: /var/lib/mysql
  volumeClaimTemplates:
  - metadata:
      name: mysql-persistent-storage
    spec:
      accessModes: ["ReadWriteOnce"]
      resources:
        requests:
          storage: 10Gi
```

## 3. Service YAML for MySQL StatefulSet

### Headless Service YAML
```yaml
apiVersion: v1
kind: Service
metadata:
  name: mysql-service
  labels:
    app: mysql
spec:
  ports:
  - port: 3306
    name: mysql
    targetPort: 3306
  clusterIP: None  # Makes this a headless service
  selector:
    app: mysql
```

## Steps to Apply the Configuration

1. **Apply the Service YAML:**
   ```bash
   kubectl apply -f mysql-service.yaml
   ```

2. **Apply the StatefulSet YAML:**
   ```bash
   kubectl apply -f mysql-statefulset.yaml
   ```

3. **Verify StatefulSet and Pods:**
   ```bash
   kubectl get statefulset
   kubectl get pods
   ```

4. **Verify the Service:**
   ```bash
   kubectl get service mysql-service -o yaml
   
