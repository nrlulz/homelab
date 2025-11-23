{{- define "pgcluster.instanceName" -}}
{{- .Values.databaseName }}-cluster-v{{ .Values.generation }}
{{- end }}
