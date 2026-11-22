{{/*
Scheduling settings of the relay pod.
*/}}
{{- define "relay.scheduling" -}}
{{- if .Values.nodeName }}
nodeName: {{ .Values.nodeName }}
{{- else if .Values.deployment.nodeSelector }}
nodeName: {{ .Values.deployment.nodeSelector }}
{{- end }}
{{- with .Values.imagePullSecrets }}
imagePullSecrets:
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
