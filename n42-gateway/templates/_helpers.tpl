{{/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
  *
  *  Name (defaults to "n42-gateway") and a fully qualified name
  *  (defaults to "<release>-n42-gateway") of controller and a variant with `.Values.defaultBackend.name`
  *  for the default backend.
  *
  *  We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
  *  If release name contains the chart name, it will be used as a full name.
  *
  */}}
{{- define "n42-gateway.name" -}}
  {{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "n42-gateway.fullname" -}}
  {{- if .Values.fullnameOverride }}
    {{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
  {{- else }}
    {{- $name := default .Chart.Name .Values.nameOverride }}
    {{- if contains $name .Release.Name }}
      {{- .Release.Name | trunc 63 | trimSuffix "-" }}
    {{- else if eq .Release.Name "n42" }}
      {{- $name | trunc 63 | trimSuffix "-" }}
    {{- else }}
      {{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
    {{- end }}
  {{- end }}
{{- end }}

{{- define "n42-gateway.defaultBackend.name" -}}
  {{- printf "%s-%s" (default .Chart.Name .Values.chartnameOverride) .Values.defaultBackend.name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "n42-gateway.defaultBackend.fullname" -}}
  {{- $name := default .Chart.Name .Values.nameOverride }}
  {{- if contains $name .Release.Name }}
    {{- printf "%s-%s" .Release.Name .Values.defaultBackend.name | trunc 63 | trimSuffix "-" }}
  {{- else }}
    {{- printf "%s-%s-%s" .Release.Name $name .Values.defaultBackend.name | trunc 63 | trimSuffix "-" }}
  {{- end }}
{{- end }}


{{/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
  *
  *  Common and selector labels
  *
  *  We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
  *
  */}}
{{- define "n42-gateway.chart" -}}
  {{- printf "%s-%s" (default .Chart.Name .Values.chartnameOverride) .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "n42-gateway.labels" -}}
helm.sh/chart: {{ include "n42-gateway.chart" . }}
{{ include "n42-gateway.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/* need to update NOTES.txt whenever update these labels */}}
{{- define "n42-gateway.selectorLabels" -}}
app.kubernetes.io/name: {{ include "n42-gateway.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "n42-gateway.defaultBackend.labels" -}}
helm.sh/chart: {{ include "n42-gateway.chart" . }}
{{ include "n42-gateway.defaultBackend.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "n42-gateway.defaultBackend.selectorLabels" -}}
app.kubernetes.io/name: {{ include "n42-gateway.defaultBackend.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}


{{/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
  *
  *  Create the name of the service account to use
  *
  */}}
{{- define "n42-gateway.serviceAccountName" -}}
  {{- if .Values.serviceAccount.create }}
    {{- default (include "n42-gateway.fullname" .) .Values.serviceAccount.name }}
  {{- else }}
    {{- default "default" .Values.serviceAccount.name }}
  {{- end }}
{{- end }}


{{/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
  *
  * Construct the path for publish-service
  * 
  */}}
{{- define "n42-gateway.controller.publishServicePath" -}}
  {{- if .Values.controller.publishService.pathOverride }}
    {{- .Values.controller.publishService.pathOverride | trimSuffix "-" }}
  {{- else }}
    {{- printf "%s/%s" "$(POD_NAMESPACE)" (include "n42-gateway.fullname" .) | trimSuffix "-" }}
  {{- end }}
{{- end }}


{{/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
  *
  * Controller name in Ingress and Gateway classes
  * 
  */}}
{{- define "n42-gateway.controller-name" -}}
  {{- if .Values.controller.fullControllerName }}
    {{- .Values.controller.fullControllerName }}
  {{- else }}
    {{- "" }}n42-gateway.github.io/controller{{ with .Values.controller.ingressClassResource.controllerClass }}/{{ . }}{{ end }}
  {{- end }}
{{- end }}
