import { Socket } from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}});

socket.connect();

const renderComments = ({comments}) => {
    document.querySelector('.collection').innerHTML =
        comments.map(comment => `
        <li class="collection-item">
            ${comment.content}
            <div class="secondary-content">
                ${comment.user ? comment.user.email : 'Anonymous'}
            </div>
        </li> 
    `).reverse().join('');
};

const commentTemplate = ({ content }) => (`
        <li class="collection-item">
            ${content}
        </li> 
`);

const renderNewComment = ({ comment }) => {
    document.querySelector('.collection').innerHTML += commentTemplate(comment);
};

export const createSocket = topicId => {
    if (topicId) {
        let channel = socket.channel(`comments:${topicId}`, {});
        channel.join()
            .receive("ok", renderComments)
            .receive("error", resp => {
                console.log("Unable to join", resp)
            });
        document.querySelector('button')
            .addEventListener('click', () => {
                const textArea = document.querySelector('textarea');
                const content = textArea.value;
                channel.push('comment:add', {content});
                textArea.value = '';
            });
        channel.on(`comments:${topicId}:new`, renderNewComment);
    }
};
