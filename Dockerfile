FROM node:alpine as builder
RUN apk update && apk add --no-cache make git

# Create app directory
WORKDIR /app

# Install app dependencies
COPY package.json package-lock.json /app/
RUN cd /app && npm set progress=false && npm install
# Copy project files into the docker image
COPY .  /app
RUN cd /app && npm run build

# STEP 2 build a small nginx image with static website
FROM nginx:alpine
## Remove default nginx website
RUN rm -rf /usr/share/nginx/html/*
## From 'builder' copy website to default nginx public folder
COPY --from=builder /app/dist/quiz-ui /usr/share/nginx/html
COPY nginx/quiz.conf.template /etc/nginx/conf.d/
EXPOSE 80
ENV QUIZ_API_HOST localhost
ENV QUIZ_API_PORT 4000
CMD envsubst '$$QUIZ_API_HOST $$QUIZ_API_PORT' < /etc/nginx/conf.d/quiz.conf.template > /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'
