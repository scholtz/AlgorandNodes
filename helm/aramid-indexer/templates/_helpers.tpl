{{/*
Scheduling settings shared by all pods of this chart.
*/}}
{{- define "indexer.scheduling" -}}
{{- with .Values.imagePullSecrets }}
imagePullSecrets:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- with .Values.nodeSelector }}
nodeSelector:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- with .Values.affinity }}
affinity:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- with .Values.tolerations }}
tolerations:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- end }}

{{/*
Init container which blocks until a TCP service is reachable.
Usage: include "indexer.waitFor" (dict "root" . "title" "DB Server" "host" "svc" "port" 5432)
*/}}
{{- define "indexer.waitFor" -}}
- name: wait-for-{{ .title | lower | replace " " "-" }}
  image: {{ .root.Values.initContainer.image }}:{{ .root.Values.initContainer.tag }}
  imagePullPolicy: {{ .root.Values.initContainer.imagePullPolicy }}
  command:
    - sh
    - -c
    - |
      echo "Checking for the availability of {{ .title }} at {{ .host }}:{{ .port }}"
      while ! nc -z {{ .host }} {{ .port }}; do sleep 1; printf "-"; done
      echo "  >> {{ .title }} has started"
  securityContext:
    runAsUser: 1000
    runAsGroup: 1000
    allowPrivilegeEscalation: false
    capabilities:
      drop:
        - ALL
{{- end }}

{{/*
Hardened container security context. Usage: include "indexer.containerSecurity" 1000
*/}}
{{- define "indexer.containerSecurity" -}}
runAsUser: {{ . }}
runAsGroup: {{ . }}
allowPrivilegeEscalation: false
capabilities:
  drop:
    - ALL
{{- end }}

{{/*
libpq connection string. Values are single-quoted with \ and ' escaped so that
special characters in the user, password or database name cannot break the DSN.
*/}}
{{- define "indexer.dsn" -}}
{{- $user := .Values.db.user | replace "\\" "\\\\" | replace "'" "\\'" -}}
{{- $pass := .Values.db.password | replace "\\" "\\\\" | replace "'" "\\'" -}}
{{- $name := .Values.db.dbName | replace "\\" "\\\\" | replace "'" "\\'" -}}
{{- printf "host=%s%s port=%v user='%s' password='%s' dbname='%s' sslmode=disable" .Values.prefix .Values.serviceDB.name .Values.serviceDB.port.service $user $pass $name -}}
{{- end }}
